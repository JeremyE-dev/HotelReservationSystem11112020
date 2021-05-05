# HotelReservationSystem11112020
Description: Minimal viable product representation of a hotel reservation system that keeps track of all room information.

Contents:
Entity-Relationship Diagram SQL creation script

Features: Rooms: Have assigned numbers, floor, and occupancy limits, types(i.e. single, double, king, etc.), amenities such as fridges, spa baths, etc.

Customer Information: name, phone, email, etc., multiple rooms booked on the same reservation.

Reservations: Have a date range and list the names and ages of all guests.

Room Rates: Rates are based on the room type and vary by date range.

Add-ons: Allows tracking of add-ons (order room service, movies, etc.)

Billing: System tracks of billing, Bill consists of a header row which contains all the total and tax information: Details table which contains detail rows with the pricing of various types of items (room charges, meals, movies, and other add on charges)

Promotion Codes: The system allows for promotion codes. The code has a date range it is valid in, may offer a percentage discount or a flat dollar amount off, and are attached to the reservation.
