import 'dart:io';
import 'print.dart';
void main() {
  PrintQueue queue = PrintQueue(10);
  bool exit = false;

  while (!exit) {
    showMenu();
    stdout.write("Pilih opsi: ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write("Masukkan nama dokumen: ");
        String? nama = stdin.readLineSync();
        stdout.write("Masukkan prioritas dokumen: ");
        int? prioritas = int.tryParse(stdin.readLineSync()!);
        if (nama != null && prioritas != null) {
          queue.enqueue(nama, prioritas);
        } else {
          print("Input tidak valid.");
        }
        break;
      case '2':
        queue.dequeue();
        break;
      case '3':
        stdout.write("Masukkan ID dokumen yang akan dibatalkan: ");
        int? id = int.tryParse(stdin.readLineSync()!);
        if (id != null) {
          queue.cancelDocument(id);
        } else {
          print("Input tidak valid.");
        }
        break;
      case '4':
        queue.displayQueue();
        break;
      case '5':
        stdout.write("Masukkan ID dokumen yang akan dicari: ");
        int? id = int.tryParse(stdin.readLineSync()!);
        if (id != null) {
          queue.searchDocumentById(id);
        } else {
          print("Input tidak valid.");
        }
        break;
      case '6':
        stdout.write("Masukkan nama dokumen yang akan dicari: ");
        String? nama = stdin.readLineSync();
        if (nama != null) {
          queue.searchDocumentByName(nama);
        } else {
          print("Input tidak valid.");
        }
        break;
      case '7':
        queue.insertionSort();
        break;
      case '8':
        exit = true;
        print("Keluar dari program.");
        break;
      default:
        print("Pilihan tidak valid.");
    }
  }
}
