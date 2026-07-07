const {onDocumentCreated, onDocumentUpdated} = require("firebase-functions/v2/firestore");
const {setGlobalOptions} = require("firebase-functions/v2");
const admin = require("firebase-admin");

// Set global options for all functions
setGlobalOptions({region: "asia-south1"});

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

exports.onNewsCreated = onDocumentCreated("news/{newsId}", async (event) => {
    const news = event.data.data();
    if (!news) return null;

    if (news.send_notification && !news.notification_sent && (news.is_published || !news.scheduled_at)) {
        return sendNotificationToAll("news", event.params.newsId, news.title, news.category || "New News Update");
    }
    return null;
});

exports.onWishCreated = onDocumentCreated("wishes/{wishId}", async (event) => {
    const wish = event.data.data();
    if (!wish) return null;

    if (wish.send_notification && !wish.notification_sent && (wish.is_published || !wish.scheduled_at)) {
        return sendNotificationToAll("wishes", event.params.wishId, wish.title, wish.tag || "New Celebration");
    }
    return null;
});

exports.onAnnouncementCreated = onDocumentCreated("announcements/{announcementId}", async (event) => {
    const announcement = event.data.data();
    if (!announcement) return null;

    if (announcement.send_notification && !announcement.notification_sent) {
        return sendNotificationToAll("announcement", event.params.announcementId, announcement.title, announcement.category || "New Announcement");
    }
    return null;
});

exports.onNewsUpdated = onDocumentUpdated("news/{newsId}", async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();

    if (!before.is_published && after.is_published && after.send_notification && !after.notification_sent) {
        return sendNotificationToAll("news", event.params.newsId, after.title, after.category || "New News Update");
    }
    return null;
});

// NEW: Advertisement Notification
exports.onAdvertisementCreated = onDocumentCreated("advertisements/{adId}", async (event) => {
    const ad = event.data.data();
    if (!ad) return null;

    // Check if the admin app set 'send_notification'
    if (ad.send_notification && !ad.notification_sent) {
        return sendNotificationToAll("advertisement", event.params.adId, ad.title, "New village advertisement posted");
    }
    return null;
});

// NEW: Institute Notification
exports.onInstituteCreated = onDocumentCreated("institutes/{instId}", async (event) => {
    const inst = event.data.data();
    if (!inst) return null;

    // Check if the admin app set 'send_notification'
    if (inst.send_notification && !inst.notification_sent) {
        return sendNotificationToAll("institute", event.params.instId, inst.name, "New school/college added to directory");
    }
    return null;
});

async function sendNotificationToAll(type, id, title, body) {
    // We send to topics for better scalability and to match the Flutter app subscriptions
    const topic = type === "advertisement" ? "advertisements" :
                 (type === "institute" ? "institutes" :
                 (type === "announcement" ? "announcements" : type));

    const message = {
        notification: {
            title: title,
            body: body,
        },
        data: {
            type: type,
            id: id,
            click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
        topic: topic,
    };

    try {
        const response = await fcm.send(message);
        console.log(`Successfully sent topic message (${topic}):`, response);

        // Update the document to mark notification as sent
        const collectionsMap = {
            "news": "news",
            "wishes": "wishes",
            "announcement": "announcements",
            "advertisement": "advertisements",
            "institute": "institutes"
        };

        const collection = collectionsMap[type] || type;
        await db.collection(collection).doc(id).update({
            notification_sent: true,
        });

        return response;
    } catch (error) {
        console.log("Error sending topic message:", error);
        return null;
    }
}
