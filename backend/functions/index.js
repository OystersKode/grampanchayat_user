const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

exports.onNewsCreated = functions.firestore
    .document('news/{newsId}')
    .onCreate(async (snapshot, context) => {
        const news = snapshot.data();

        if (news.send_notification && !news.notification_sent && (news.is_published || !news.scheduled_at)) {
            return sendNotificationToAll('news', context.params.newsId, news.title, news.category || 'New News Update');
        }
        return null;
    });

exports.onWishCreated = functions.firestore
    .document('wishes/{wishId}')
    .onCreate(async (snapshot, context) => {
        const wish = snapshot.data();

        if (wish.send_notification && !wish.notification_sent && (wish.is_published || !wish.scheduled_at)) {
            return sendNotificationToAll('wishes', context.params.wishId, wish.title, wish.tag || 'New Celebration');
        }
        return null;
    });

exports.onAnnouncementCreated = functions.firestore
    .document('announcements/{announcementId}')
    .onCreate(async (snapshot, context) => {
        const announcement = snapshot.data();

        if (announcement.send_notification && !announcement.notification_sent) {
            return sendNotificationToAll('announcement', context.params.announcementId, announcement.title, announcement.category || 'New Announcement');
        }
        return null;
    });

// Separate trigger for scheduled items when they become published
exports.onNewsUpdated = functions.firestore
    .document('news/{newsId}')
    .onUpdate(async (change, context) => {
        const before = change.before.data();
        const after = change.after.data();

        if (!before.is_published && after.is_published && after.send_notification && !after.notification_sent) {
            return sendNotificationToAll('news', context.params.newsId, after.title, after.category || 'New News Update');
        }
        return null;
    });

async function sendNotificationToAll(type, id, title, body) {
    const tokensSnapshot = await db.collection('user_tokens').get();
    const tokens = tokensSnapshot.docs.map(doc => doc.id);

    if (tokens.length === 0) {
        console.log('No tokens found');
        return null;
    }

    const message = {
        notification: {
            title: title,
            body: body,
        },
        data: {
            type: type,
            id: id,
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
        },
        tokens: tokens,
    };

    try {
        const response = await fcm.sendEachForMulticast(message);
        console.log('Successfully sent message:', response);

        // Mark as sent to avoid duplicates
        const collection = type === 'announcement' ? 'announcements' : (type === 'wishes' ? 'wishes' : 'news');
        await db.collection(collection).doc(id).update({
            notification_sent: true
        });

        return response;
    } catch (error) {
        console.log('Error sending message:', error);
        return null;
    }
}
