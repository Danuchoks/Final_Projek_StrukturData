import 'dart:io';

// Class untuk merepresentasikan dokumen
class Document {
  String nama;
  int prioritas;
  int id;

  Document(this.nama, this.prioritas, this.id);
}

// Class untuk Queue menggunakan list dengan front dan rear
class PrintQueue {
  List<Document?> _elements;
  int _front;
  int _rear;
  int _maxQueue;
  int _idCounter;

  PrintQueue(int max)
      : _front = 0,
        _rear = -1,
        _maxQueue = max,
        _idCounter = 1,
        _elements = List<Document?>.filled(max, null);

  bool isEmpty() {
    return _rear == -1 && _front == 0;
  }

  bool isFull() {
    return _rear == _maxQueue - 1;
  }

  void enqueue(String nama, int prioritas) {
    if (isFull()) {
      print("Queue Overflow, tidak dapat mengisi data lagi");
    } else {
      _rear += 1;
      _elements[_rear] = Document(nama, prioritas, _idCounter++);
      print(
          "Dokumen '${nama}' dengan ID ${_elements[_rear]!.id} dan prioritas ${prioritas} ditambahkan ke antrian.");
      saveQueueToFile();
    }
  }

  Document? dequeue() {
    if (isEmpty()) {
      print("Queue Underflow");
      return null;
    } else {
      Document? data = _elements[_front];
      _elements[_front] = null;
      _front += 1;
      if (_front > _rear) {
        // antrian di-reset dengan mengatur front kembali ke 0 dan rear kembali ke -1.
        _front = 0;
        _rear = -1;
      }
      print(
          "Dokumen '${data!.nama}' dengan ID ${data.id} dan prioritas ${data.prioritas} sedang dicetak.");
      saveQueueToFile();
      return data;
    }
  }

  void cancelDocument(int id) {
    bool found = false;
    for (int i = _front; i <= _rear; i++) {
      if (_elements[i] != null && _elements[i]!.id == id) {
        print(
            "Dokumen '${_elements[i]!.nama}' dengan ID ${_elements[i]!.id} telah dibatalkan.");
        _elements[i] = null;
        found = true;
        break;
      }
    }
    if (!found) {
      print("Dokumen dengan ID $id tidak ditemukan.");
    }
    saveQueueToFile();
  }

  void displayQueue() {
    if (isEmpty()) {
      print("Antrian kosong.");
    } else {
      print("Daftar dokumen dalam antrian:");
      for (int i = _front; i <= _rear; i++) {
        if (_elements[i] != null) {
          print(
              "ID: ${_elements[i]!.id}, Nama: ${_elements[i]!.nama}, Prioritas: ${_elements[i]!.prioritas}");
        }
      }
    }
  }

  void searchDocumentById(int id) {
    bool found = false;
    for (int i = _front; i <= _rear; i++) {
      if (_elements[i] != null && _elements[i]!.id == id) {
        print(
            "Dokumen ditemukan: ID: ${_elements[i]!.id}, Nama: ${_elements[i]!.nama}, Prioritas: ${_elements[i]!.prioritas}");
        found = true;
        break;
      }
    }
    if (!found) {
      print("Dokumen dengan ID $id tidak ditemukan.");
    }
  }

  void searchDocumentByName(String nama) {
    bool found = false;
    for (int i = _front; i <= _rear; i++) {
      if (_elements[i] != null && _elements[i]!.nama == nama) {
        print(
            "Dokumen ditemukan: ID: ${_elements[i]!.id}, Nama: ${_elements[i]!.nama}, Prioritas: ${_elements[i]!.prioritas}");
        found = true;
        break;
      }
    }
    if (!found) {
      print("Dokumen dengan nama '$nama' tidak ditemukan.");
    }
  }

  void insertionSort() {
    for (int i = _front + 1; i <= _rear; i++) {
      Document? key = _elements[i];
      int j = i - 1;
      while (j >= _front && _elements[j] != null && key != null && _elements[j]!.prioritas > key.prioritas) {
        _elements[j + 1] = _elements[j];
        j = j - 1;
      }
      _elements[j + 1] = key;
    }
    print("Antrian telah diurutkan berdasarkan prioritas.");
    saveQueueToFile();
  }

  // Fungsi untuk menyimpan antrian ke dalam file CSV
  void saveQueueToFile() {
    List<String> rows = [];
    rows.add('ID,Nama,Prioritas');
    for (int i = _front; i <= _rear; i++) {
      if (_elements[i] != null) {
        rows.add('${_elements[i]!.id},${_elements[i]!.nama},${_elements[i]!.prioritas}');
      }
    }
    File file = File('daftar_antrian.csv');
    file.writeAsStringSync(rows.join('\n'));
    print("Antrian telah disimpan ke dalam file daftar_antrian.csv.");
  }
}

void showMenu() {
  print("Menu Utama:");
  print("1. Tambah Dokumen ke Antrian");
  print("2. Cetak Dokumen");
  print("3. Batalkan Pencetakan Dokumen");
  print("4. Lihat Daftar Antrian");
  print("5. Cari Dokumen Berdasarkan ID");
  print("6. Cari Dokumen Berdasarkan Nama");
  print("7. Urutkan Antrian Berdasarkan Prioritas");
  print("8. Keluar");
}


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
