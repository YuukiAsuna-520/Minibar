# Minibar
A guest-only minibar app to order items and schedule a replenishment time slot, showcasing OOP + Protocol-Oriented design with MVVM, validation, unit tests, and Git.

## Features
- **Login:** 4-digit room number only (e.g., “0808”); invalid input shows a system alert.
- **Products:** List items and **Add**; items **merge** by (room + product), increasing quantity instead of duplicating rows.
- **Time Slot:** Pick start/end, validate, **Save/Cancel**; show saved slot and allow edit/delete.
- **Order History:** Per-room list; swipe **Edit** (quantity 1…20) / **Delete**; **Sign out** returns to login.

## Architecture (MVVM + Store)
- **Models:** `Product`, `OrderItem`, `TimeSlot` (value types, `Identifiable/Equatable`).
- **Protocols:**  
  - `OrderManaging`: add/delete/update orders  
  - `Scheduling`: exposes `scheduledSlot`
- **Store:** `AppStore` (`ObservableObject`) conforms to both protocols and publishes `products`, `orders`, `scheduledSlot`.
- **ViewModel:** `ScheduleViewModel` owns time-slot state, validation, save/delete.
- **Views:** `LoginView`, `GuestTabView` (tabs), `ProductsView`, `TimeSlotView`, `OrderHistoryView`.

## Error Handling
- **Login:** strict 4-digit check → system **Alert**.
- **Time Slot:** inline messages for invalid ranges/duration; `save(...)` returns boolean and sets `errorMessage`.
- **History:** destructive delete; quantity clamped.

## Tests (Unit only)
- `ScheduleViewModelTests`:
  - invalid slot → save fails + error message
  - valid slot → save succeeds and updates `AppStore.scheduledSlot`
  - delete → clears slot
