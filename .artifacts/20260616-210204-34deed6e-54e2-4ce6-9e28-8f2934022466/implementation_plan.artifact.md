# Implementation Plan - Taluka Schools & Colleges

This plan outlines the steps to add a new "Taluka Schools & Colleges" section to both the Admin and User applications.

## User Review Required

- **Collection Name**: I'll use `institutes` as the Firestore collection name.
- **Image Upload**: For the Admin app, I'll use the existing Cloudinary integration for image uploads.
- **Localization**: I'll add translations for "Schools & Colleges" and related fields in English and Kannada.

## Proposed Changes

### Admin Application

#### [NEW] [institute_model.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_admin/lib/admin/models/institute_model.dart)
- Define `Institute` class with fields: `id`, `name`, `imageUrl`, `contactNumber`, `email`, `website`.

#### [NEW] [institute_service.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_admin/lib/admin/services/institute_service.dart)
- CRUD operations for `institutes` collection.
- Support image upload to Cloudinary.

#### [NEW] [manage_institutes_screen.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_admin/lib/admin/screens/manage_institutes_screen.dart)
- Screen to list, add, edit, and delete institutes.

#### [admin_drawer.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_admin/lib/admin/widgets/admin_drawer.dart)
- Add "Manage Schools & Colleges" to the drawer.

---

### User Application

#### [NEW] [institute_model.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_user/lib/data/models/institute_model.dart)
- Mirror model for the user app.

#### [app_repository.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_user/lib/data/repositories/app_repository.dart)
- Add `getInstitutes()` method.

#### [app_translations.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_user/lib/core/localization/app_translations.dart)
- Add strings: `taluka_institutes`, `institute_name`, `contact_no`, `website`, `email`, etc.

#### [NEW] [institutes_screen.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_user/lib/presentation/screens/institutes/institutes_screen.dart)
- Screen to display the list of institutes with search and contact options.

#### [app_routes.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_user/lib/routes/app_routes.dart)
- Add route for `/institutes`.

#### [sidebar.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_user/lib/presentation/widgets/sidebar.dart)
- Add "Schools & Colleges" to the user drawer.

## Verification Plan

### Manual Verification
- **Admin App**:
    - Add a new institute with an image and all details.
    - Edit an existing institute.
    - Delete an institute.
- **User App**:
    - Verify the new section appears in the drawer.
    - Verify all added institutes are displayed correctly.
    - Test the "Call", "Email", and "Website" buttons (verify they launch respective apps/URLs).
    - Test search functionality.
