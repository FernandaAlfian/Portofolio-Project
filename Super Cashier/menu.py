import modul
import pandas as pd

    

user_id = input("Mohon masukkan user ID Anda: ")
print(f'Hallo user {user_id}!\nSelamat datang di ABCD Mart!\n\n')
trnsct_123 = modul.Transaction()

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
#    menu()

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
        

menu()





