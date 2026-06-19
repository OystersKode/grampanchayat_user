# Implementation Plan - Advertisements Section

This plan outlines the steps to add an "Advertisements" section to both the Admin and User applications.

## User Review Required

- **Placement in User App**: I'll add a dedicated "Advertisements" screen accessible from the sidebar.
- **Display Style**: Advertisements will be shown as a list of cards with an image, bold title, and description.

## Proposed Changes

### Admin Application

#### [NEW] [advertisement_model.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_admin/lib/admin/models/advertisement_model.dart)
- Fields: `id`, `imageUrl`, `title`, `description`.

#### [NEW] [advertisement_service.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_admin/lib/admin/services/advertisement_service.dart)
- CRUD for `advertisements` collection.
- Image upload to Cloudinary.

#### [NEW] [manage_advertisements_screen.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_admin/lib/admin/screens/manage_advertisements_screen.dart)
- Admin UI to manage ads.

#### [admin_drawer.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_admin/lib/admin/widgets/admin_drawer.dart)
- Add "Manage Advertisements".

---

### User Application

#### [NEW] [advertisement_model.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_user/lib/data/models/advertisement_model.dart)
- Mirror model.

#### [app_repository.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_user/lib/data/repositories/app_repository.dart)
- Add `getAdvertisements()`.

#### [NEW] [advertisements_screen.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_user/lib/presentation/screens/advertisements/advertisements_screen.dart)
- Display ads list.

#### [app_translations.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_user/lib/core/localization/app_translations.dart)
- Add "Advertisements" translations.

#### [sidebar.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_user/lib/presentation/widgets/sidebar.dart)
- Add "Advertisements" to drawer.

#### [app_routes.dart](file:///D:/Radrix/Kagwad Grampanchayat/grampanchayat_user/lib/routes/app_routes.dart)
- Add `/advertisements` route.

## Verification Plan

### Manual Verification
- **Admin**: Add/Edit/Delete an advertisement.
- **User**: View advertisements in the list, verify images and text are displayed correctly.
