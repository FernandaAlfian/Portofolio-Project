
# Super Cashier - Python Project

Super Cashier adalah program self-service cashier supermarket sederhana untuk cosumer dapat langsung menginputkan item, jumlah dan harga yang ingin dibeli. 

# Case Problems
- Pemilik supermarket ingin melakukan perbaikan proses bisnis dengan membuat self-service kasir, sehingga customer dapat membeli barang dari supermarket secara langsung menginputkan pesanannya tanpa perlu memiliki banyak pegawai untuk menghandle pekerjaan sebagai kasir.

# Feature Requirements
- Dapat membuat ID Transaksi Customer.
- Dapat menginputkan nama, jumlah, dan harga item yang ingin dibeli.
- Dapat melakukan update nama, jumlah, atau harga item yang telah diinput.
- Dapat menghapus salah satu item yang telah diinput.
- Dapat menghapus seluruh item yang telah diinput.
- Dapat menampilkan list transaksi yang telah diinput.
- Dapat menghitung total belanja yang ingin beli.
- Membuat UI sederhana untuk menjalankan features yang ada.

# Flowchart
![Flowchart Super Cashier](https://user-images.githubusercontent.com/98755428/227398802-b7402b40-2d17-4a89-a334-dbee3bdbe87d.png)



# Program Functions

Project ini memiliki 3 file, `modul.py`, `menu.py`, `main.py`.
1. `modul.py`
    File ini berisi class Transaction yang menampung berbagai fungsi untuk dapat dipakai pada file menu. 
2. `menu.py`
    File ini berisi main menu, dan fungsi lain dari class Transaction untuk dapat dipilih consumer pada main menu.
3. `main.py`
    File ini adalah file untuk menjalankan main menu dari super cashier

Berikut adalah penjelasan dari file di atas.

Modul `main.py`

Mothod ``__init__()``
```py 
    def __init__(self):

            self.keranjang = {}
            self.total_belanja = 0
```


Mothod ``checklist_list_order()``
```py 
    def check_list_order(self):
        """
        Fungsi ini adalah untuk mmengeluarkan visual dari keranjang belanja yang dibeli.
        
        Output akan terlihat seperti:

        Item Belanja        Jumlah      Harga       Total Harga
        Item 1                 1       10000           10000
        Item 2                 2       20000           40000

        Fungsi ini akan ada di dalam fungsi lain dalam class Transaction untuk menyederhanakan script
        """
        print ("\n")
        print("------------ Super Cashier -------------")
        print("---------- Keranjang Belanja  ----------\n")
        kolom = pd.DataFrame.from_dict(self.keranjang, orient='index', columns=['Jumlah', 'Harga', 'Total Harga'])
        print(kolom)
        print ("\n")
```

Mothod ``add_item()``
```py 
   def add_item(self):
        """
        Fungsi ini adalah input dari pembeli untuk menginputkan beberapa item seperti:
            1. Nama Item
            2, Jumlah Item
            3. Harga Item
        
        Variabel Total harga adalah hasil dari jumlah item * harga item.

        """

        print("\n------------ Super Cashier -------------")
        print("------------- Add Item  -------------\n")
        while True:
            nama_item = input("Masukkan Nama Item: ")
            print ("\n")

            if len(nama_item) < 3:
                print("Nama item tidak bisa kurang dari tiga karakter")
                continue
            else:
                break

        while True:
            try:
                jumlah_item = int(input("Masukkan jumlah item: "))
                harga_item = int(input("Masukkan harga item: "))
                print ("\n")
                break 
            except:
                print("Masukkan input berupa angka")
                continue


        if nama_item in self.keranjang:
            print(f'{nama_item} Terdapat pada keranjang. Item akan di update.')
            print ("\n")

            #variabel untuk menampung jumlah baru
            jumlah_baru = self.keranjang[nama_item][0] + jumlah_item
            harga_total = self.keranjang[nama_item][1] * jumlah_baru

            # update keranjang jumlah_baru
            self.keranjang[nama_item][0] = jumlah_baru
            self.keranjang[nama_item][2] = harga_total

        else:    
            # menambahkan nama item ke keranjang
            total_harga = jumlah_item * harga_item
            self.keranjang[nama_item] = [jumlah_item, harga_item, total_harga]

            print(f'item {nama_item} dengan jumlah {jumlah_item} item berhasil ditambahkan')


        while True:
            print ("\n")
            add_more = input("ingin menambahkan item lain? (yes/no): ").lower()
            print ("\n")
            if add_more == 'yes':
                self.add_item()
                pass
            elif add_more == 'no':
                break
            else: 
                print("Masukkan hanya kata yes / no")
                continue

         
        ## Menampilkan keranjang belanja
        self.check_list_order()

        return 

```

Mothod ``update_name_item()``
```py 
    def update_name_item(self):
        """
        Fungsi ini adalah untuk melakukan update nama item jika terdapat kesalahan pada penginputan nama.

        Pembeli akan menginputkan nama item yang akan diubah, jika tidak ada dalam item maka akan dilakukan looping sampai nama item yang ada pada keranjang terpilih.
        Jika nama item benar, maka akan dilakukan perubahan nama item menjadi nama item yang baru, dan delete nama item yang lama.
        """
        print("\n------------ Super Cashier -------------")
        print("----------- Update Nama Item  -----------\n")

        # Cek keranjang kosong atau tidak
        if len(self.keranjang) == 0:
            print("Keranjang Anda masih kosong")
            return # Kembali ke menu     
        
        self.check_list_order()


        while True:
            try:
                # Membuat nama item lama dan baru yang akan diganti
                nama_item = input("Masukkan nama Item yang ingin Anda ubah: ")

                # Cek nama item dalam keranjang
                # Jika ada dapat merubah nama item baru
                # Jika tidak, akan looping sampai nama item yang akan diubah ada dalam keranjang
                if nama_item in self.keranjang:
                    print(f"\nItem {nama_item} ada dalam keranjang!\n") 
                    break
                else:
                    print(f"\nItem {nama_item} tidak ada dalam keranjang. \nMasukkan nama Item dengan benar.\n") 
                    pass  # Looping sampai user menginputkan nama dengan benar
                
            except:
                break

        nama_item_baru = input("Masukkan nama baru: ")
        print ("\n")

        # Memanggil nama item pada keranjang untuk diubah menjadi nama item baru
        # Delete keranjang nama item yang lama
        self.keranjang[nama_item_baru] = self.keranjang[nama_item]

        # Menghapus nama item yang lama
        del self.keranjang[nama_item]


        print(f'Nama Item {nama_item} berhasil diubah menjadi {nama_item_baru}')
        
        self.check_list_order()


        while True:
            print ("\n")
            add_more = input("ingin mengubah nama item lain? (yes/no): ").lower()
            print ("\n")
            if add_more == 'yes':
                self.update_name_item() # masuk ke fungsi update_name_item
                pass
            elif add_more == 'no':
                break
            else: 
                print("Masukkan hanya kata yes / no") 
                continue # looping jika input yang dimasukkan bukan yes/no

        self.check_list_order()

        return

```

Mothod ``update_quantity_item()``
```py 
   def update_quantity_item(self):
        """
        Fungsi ini adalah untuk melakukan update pada jumlah item yang diinputkan pembeli.

        """

        print("\n------------ Super Cashier -------------")
        print("------------ Update Quantity  ------------\n")

        # Cek keranjang kosong atau tidak
        if len(self.keranjang) == 0:
            print("Keranjang Anda masih kosong")
#            self.menu.menu()
            return       # Kembali ke menu     
        
        self.check_list_order()


        while True:     
            try:
                # Membuat nama item lama dan baru yang akan diganti
                nama_item = input("Masukkan nama Item yang ingin Anda ubah: ")

                # Cek nama item dalam keranjang
                # Jika ada dapat merubah nama item baru
                # Jika tidak, akan looping sampai nama item yang akan diubah ada dalam keranjang
                if nama_item in self.keranjang:
                    print(f"\nItem {nama_item} ada dalam keranjang!\n") 
                    break
                else:
                    print(f"\nItem {nama_item} tidak ada dalam keranjang. \nMasukkan nama Item dengan benar.\n") 
                    pass  # Looping sampai user menginputkan nama dengan benar
                
            except:
                break

        while True:
                try:

                    jumlah_baru = int(input("Jumlah item yang yang ingin diubah: "))
                    print ("\n")
                    break

                except:

                    print("Harap masukkan angka")
                    pass


        
        # Input jumlah baru yang ingin diubah
        # Memanggil nama item pada keranjang untuk diubah menjadi nama item baru
        # Delete keranjang nama item yang lama
        self.keranjang[nama_item][0] = jumlah_baru

        total_harga_baru = self.keranjang[nama_item][1] * jumlah_baru
        self.keranjang[nama_item][2] = total_harga_baru

        
        print(f'Jumlah dari Item {nama_item} berhasil diubah menjadi {jumlah_baru}')

        self.check_list_order()

        while True:
            print ("\n")
            add_more = input("ingin mengubah jumlah item lain? (yes/no): ").lower()
            print ("\n")
            if add_more == 'yes':
                self.update_quantity_item()
                pass
            elif add_more == 'no':
                break
            else: 
                print("Masukkan hanya kata yes / no")
                continue

        self.check_list_order()
        return

```

Mothod ``update_price_item()``
```py 
    def update_price_item(self):
        """
        Fungsi ini adalah untuk melakukan update harga item
        
        """
        print("\n------------ Super Cashier -------------")
        print("------------ Update Price  ------------\n")

        # Cek keranjang kosong atau tidak
        if len(self.keranjang) == 0:
            print("Keranjang Anda masih kosong")
            return       # Kembali ke menu     
        
        self.check_list_order()

        while True:     
            try:
                # Membuat nama item lama dan baru yang akan diganti
                nama_item = input("Masukkan nama Item yang ingin Anda ubah harganya: ")

                # Cek nama item dalam keranjang
                # Jika ada dapat merubah nama item baru
                # Jika tidak, akan looping sampai nama item yang akan diubah ada dalam keranjang
                if nama_item in self.keranjang:
                    print(f"\nItem {nama_item} ada dalam keranjang!\n") 
                    break
                else:
                    print(f"\nItem {nama_item} tidak ada dalam keranjang. \nMasukkan nama Item dengan benar.\n") 
                    pass  # Looping sampai user menginputkan nama dengan benar
                
            except:
                break

        # Input harga baru yang ingin diubah
        while True:
            try:

                harga_baru = int(input("Harga baru dari item yang yang ingin diubah: "))
                print ("\n")
                break

            except:

                print("Harap masukkan angka")
                pass

        # Memanggil nama item pada keranjang untuk diubah menjadi nama item baru
        # Delete keranjang nama item yang lama
        self.keranjang[nama_item][1] = harga_baru

        total_harga_baru = self.keranjang[nama_item][0] * harga_baru
        self.keranjang[nama_item][2] = total_harga_baru
        # Print update berhasil

        print(f'Jumlah dari Item {nama_item} berhasil diubah menjadi {harga_baru}')

        self.check_list_order()

        while True:
            print ("\n")
            add_more = input("Ingin mengubah item lain? (yes/no): ").lower()
            print ("\n")
            if add_more == 'yes':
                self.update_price_item()
                pass
            elif add_more == 'no':
                break
            else: 
                print("Masukkan hanya kata yes / no")
                continue

        self.check_list_order()

        return
  
```

Mothod ``delete_item()``
```py 
    def delete_item(self):
        """
        Fungsi ini akan menghapus satu item dari input user
        """
        print("\n------------ Super Cashier -------------")
        print("------------- Delete Item  -------------\n")
        
        if len(self.keranjang) == 0:
            print("Keranjang Anda masih kosong")
            return       # Kembali ke menu     
        
        self.check_list_order()


        while True:     
            try:
                # Membuat nama item lama dan baru yang akan diganti
                nama_item = input("Masukkan nama item yang ingin Anda hapus dari keranjang: ")

                # Cek nama item dalam keranjang
                # Jika ada dapat merubah nama item baru
                # Jika tidak, akan looping sampai nama item yang akan diubah ada dalam keranjang
                if nama_item in self.keranjang:
                    print(f"\nItem {nama_item} ada dalam keranjang!\n") 
                    break
                else:
                    print(f"\nItem {nama_item} tidak ada dalam keranjang. \nMasukkan nama Item dengan benar.\n") 
                    pass  # Looping sampai user menginputkan nama dengan benar
                
            except:
                break


        # Input ("Apakah yakin ingin menghapus item {input} (yes/no)")
        while True:
            print ("\n")
            want_delete = input(f"Apakah anda yakin menghapus item {nama_item}? (yes/no): ").lower()
            print ("\n")
            if want_delete == 'yes':
                break
            elif want_delete == 'no':
                return
            else: 
                print("Masukkan hanya kata yes / no")
                continue

        # Menghapus item dalam keranjang
        del self.keranjang[nama_item]

        # Print Nama item berhasil dihapus
        print(f'Item {nama_item} berhasil dihapus dalam keranjang!')


        # Lihat Keranjang
        self.check_list_order()
        return

```

Mothod ``reset_order()``
```py 
    def reset_order(self):
        """
        Fungsi ini akan menghapus serluruh item yang telah diinputkan
        """
        print("\n------------ Super Cashier -------------")
        print("------------ Reset Order  ------------\n")

        # Cek keranjang kosong atau tidak
        if len(self.keranjang) == 0:
            print("Keranjang Anda masih kosong")
            return
            

        while True:
            print ("\n")
            want_reset = input(f"Apakah anda yakin menghapus seluruh item dalam keranjang? (yes/no): ").lower()
            print ("\n")
            if want_reset == 'yes':
                break   # ke next step
            elif want_reset == 'no':
                return  # keluar dari fungsi
            else: 
                print("Masukkan hanya kata yes / no")
                continue # looping

        self.check_list_order()

        # Clear Keranjang 
        self.keranjang.clear()

        print("Anda berhasil menghapus seluruh item dalam keranjang!")
        # Kembali ke menu
        return 
   
```

Mothod ``list_order()``
```py 
    def list_order(self):
                """
        Fungsi ini akan menampilkan keranjang dari item yang dibeli.
        """
        print("\n------------ Super Cashier -------------")
        print("------------ List Transaction  ------------\n")
        if len(self.keranjang) == 0:
            print("Anda tidak memiliki item pada keranjang")
            return
        else:
            kolom = pd.DataFrame.from_dict(self.keranjang, orient='index', columns=['Jumlah', 'Harga', 'Total Harga'])
            print(kolom)

        return
  
```

Mothod ``total_price()``
```py 
    def total_price(self):
                """"
        Fungsi ini akan menampilkan total belanja yang dibeli.
        
        Dengan kondisional sebagai berikut. 
            a. Jika total belanja di atas Rp 200.000 akan mendapatkan diskon 5%
            b. Jika total belanja di atas Rp 300.000 akan mendapatkan diskon 8%
            c. Jika total belanja di atas Rp 500.000 akan mendapatkan dikon 10%
            d. Jika di bawah Rp 200.000 maka akan langsung menampilkan total harga belanja
        """

        print("\n------------ Super Cashier -------------")
        print("------------ Total Price  ------------\n")
        
        for item in self.keranjang:  
            self.total_belanja += self.keranjang[item][2]
        
        print(f'Total belanja anda adalah {self.total_belanja}')

        if self.total_belanja > 500000:
            diskon = 0.1
            print(f'Total belanja Anda di atas Rp 500000 \nSelamat Anda mendapatkan diskon sebesar 10%')
        elif self.total_belanja > 300000:
            diskon = 0.08
            print(f'Total belanja Anda di atas Rp 300000 \nSelamat Anda mendapatkan diskon sebesar 8%')
        elif self.total_belanja > 200000:
            diskon = 0.05
            print(f'Total belanja Anda di atas Rp 200000 \nSelamat Anda mendapatkan diskon sebesar 5%')
        else:
            diskon = 0

        total_diskon = diskon * self.total_belanja
        total_harga_diskon = self.total_belanja - total_diskon

        print(f'Total belanja Anda Rp {total_harga_diskon}')
        
        return total_harga_diskon
  
```

Mothod ``exit()``
```py 
    def exit(self):
        """"
        Fungsi ini akan menampilkan pesan bahwa pembeli sudah selesai menggunakan dan akan keluar dari self-service cashier
        """
        print("\n------------ Super Cashier -------------\n")
        print("------ Terima Kasih Telah Berbelanja  ------\n")
        print("\n-------------- ABCD Mart ---------------\n")
        return
```


Modul `menu.py`


```py
def add_item():
    trnsct_123.add_item()
    menu()

def update_name_item():
    trnsct_123.update_name_item()
    menu()

def update_quantity_item():
    trnsct_123.update_quantity_item()
    menu()

def update_price_item():
    trnsct_123.update_price_item()
    menu()

def delete_item():
    trnsct_123.delete_item()
    menu()

def reset_order() :
    trnsct_123.reset_order()
    menu()

def list_order():
    trnsct_123.list_order()
    menu()

def total_price():
    trnsct_123.total_price()
    menu()

def exit():
    trnsct_123.exit()


def menu():
    """
    Daftar fitur Super Cashier
    Input angka sesuai daftar yg ada untuk menjalankan fitur
    """
    print("\n------------ Super Cashier -------------")
    print("\n-------------- App Menu ----------------")
    print("""
    1. Add Item
    2. Update Item Name
    3. Update Item Quantity
    4. Update Item Price
    5. Delete Item
    6. Reset Transaction
    7. Check Order
    8. Total Price
    9. Exit
    """)
    print("----------------------------------------\n")


    while True:
        fitur = int(input("Pilih menu yang ingin dipilih: "))
        if fitur <= 0 or fitur >= 10:
            print("Mohon agar dapat diisi angka pada menu")
            continue
        else:
            pass
        break


    if fitur == 1:
        add_item()

    elif fitur == 2:
        update_name_item()

    elif fitur == 3:
        update_quantity_item()
    
    elif fitur == 4: 
        update_price_item()

    elif fitur == 5: 
        delete_item()

    elif fitur == 6: 
        reset_order()

    elif fitur == 7: 
        list_order()

    elif fitur == 8: 
        total_price()

    elif fitur == 9: 
        exit()
        return
        
```

Modul `main.py`

```py
import menu

menu.menu()
```


# Test Case

Pada tahap ini akan dilakukan test code, untuk dapat melihat output yang dikeluarkan sudah sesuai dengan ekspektasi yang diinginkan.

Test

1. Customer ingin menambahkan dua item baru menggunakan method `add_item()`. Item yang akan ditambahkan sebagai berikut:
    - Nama Item: Ayam Goreng, Quantity 2, Harga: 20000
    - Nama Item: Pasta Gigi, Quantity 3, Harga: 15000

    Expected Output:

    ```
    Item yang dibeli adalah: {'Ayam Goreng': [2, 20000], 'Pasta Gigi': [3, 15000]}
    ```

    Output Realization:

    ![Test Case 1](https://user-images.githubusercontent.com/98755428/227463064-a0f2198b-f372-4afd-b9ef-46aaeb10fa09.png)

2. Customer ingin menghapus salah satu item yang sudah ditambahkan menggunakan method `delete_item()`. Item yang akan dihapus adalah item Pasta Gigi.

    Expected Output:

    ```
    {'Ayam Goreng': [2, 20000]}
    ```

    Output Realization:
    
    ![Test Case 2](https://user-images.githubusercontent.com/98755428/227463181-aed7aeb9-323b-417e-81ad-80774ef6e105.png)


3. Customer ingin menghapus seluruh item yang telah diinput, method yang digunakan adalah `reset_transaction()`.

    Expected Output:

    ```
    Semua item berhasil di delete!
    ```

    Output Realization:
    
    ![Test Case 3](https://user-images.githubusercontent.com/98755428/227463249-51067101-ea8d-40ea-a16d-325a24d4a5a4.png)


4. Customer menginputkan kembali item yang akan dibeli.
    - Item: Ayam Goreng, Quantity: 2, Harga: 20000
    - Item: Pasta Gigi, Quantity: 3, Harga: 15000
    - Item: Mainan Mobil, Quantity: 1, Harga: 200000
    - Item: Mi Instan, Quantity: 5, Harga: 3000

    Expected Output:

    ```
    Item yang dibeli adalah: {'Ayam Goreng': [2, 20000], 'Pasta Gigi': [3, 15000], 'Mainan Mobil': [1, 200000], 'Mi Instan': [5, 3000]}
    ```

    Output Realization:
    
    ![Test Case 4](https://user-images.githubusercontent.com/98755428/227463288-e19bbb03-6a0d-4fe1-acf2-594de4099595.png)


5. Customer ingin menghitung total belanja yang telah ada pada keranjang menggunakan method `total_price()`. 

    Expected Output:

    ```
    Item yang dibeli adalah: {'Ayam Goreng': [2, 20000], 'Pasta Gigi': [3, 15000], 'Mainan Mobil': [1, 200000], 'Mi Instan': [5, 3000]}
    
    Total Belanja yang harus dibayarkan adalah: Rp. 285000.0
    ```

    Output Realization:
    
    ![Test Case 5](https://user-images.githubusercontent.com/98755428/227463334-f319a599-7c9c-49d0-8f07-785b0a23da5a.png)

# Conclution

Berdasarkan requrements yang ada pada promblem case cashier ini, seluruh requremetns dapat dijalankan sesuai dengan ekspetkasi yang diinginkan, dan terdapat pernyesuaian dalam pengerjaannya untuk dapat lebih mempermudah consumer dalam menggunakan program super cashier ini. Program sederhana super cashier dapat digunakan, dan masih dapat dilakukan pengembangan di kemudian hari.

# Future Development

1. Agar dapat juga menggunakan Graphic User Interface agar tampilan lebih interaktif
2. Dapat membuat dictionary untuk masing2 transaction ID, sehingga dapat menampung data transaction pada masing2 user.

