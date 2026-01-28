import 'dart:io';

// a. Kelas Induk (Contact)
class Contact {
  String name;
  String phone;

  // Constructor untuk mengisi properti
  Contact(this.name, this.phone);

  // Method display()
  String display() {
    return "$name • $phone";
  }
}

// b. Dua Kelas Turunan (Inheritance)
// 1. PersonalContact
class PersonalContact extends Contact {
  DateTime? birthDate; // Properti opsional

  // Constructor
  PersonalContact(String name, String phone, this.birthDate)
    : super(name, phone); // Memanggil constructor induk

  // Override display()
  @override
  String display() {
    String dob = "";
    if (birthDate != null) {
      // Tampilkan DOB hanya jika tidak null, Format YYYY-MM-DD
      String formattedDate = birthDate!.toIso8601String().split('T')[0];
      dob = " • DOB: $formattedDate";
    }
    return "[Personal] $name • $phone$dob";
  }
}

// 2. BusinessContact
class BusinessContact extends Contact {
  String company; // Properti tambahan

  // Constructor
  BusinessContact(String name, String phone, this.company)
    : super(name, phone); // Memanggil constructor induk

  // Override display()
  @override
  String display() {
    return "[Business] $name • $phone • $company";
  }
}

// c. Objek & Polymorphism
void main() {
  // List yang menampung berbagai tipe Contact
  List<Contact> contacts = [
    // a) Objek Contact biasa
    Contact("Andi", "081234567890"),

    // b) Objek PersonalContact (punya birthDate)
    PersonalContact("Budi", "0856789012", DateTime(1995, 10, 20)),

    // c) Objek BusinessContact (punya company)
    BusinessContact("PT. Maju Jaya", "024-555666", "Software House"),

    // Contoh PersonalContact tanpa birthDate
    PersonalContact("Citra", "0987654321", null),
  ];

  print("--- Daftar Kontak ---");

  // Perulangan untuk menunjukkan polymorphism
  for (var contact in contacts) {
    // Meskipun tipe di list adalah Contact, yang dijalankan adalah display() milik subclass masing-masing
    print(contact.display());
  }
}
