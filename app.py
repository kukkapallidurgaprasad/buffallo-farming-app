import streamlit as st

st.title("🐃 Buffalo Farming App")

st.write("Welcome to Buffalo Farming Information System")

menu = st.sidebar.selectbox(
    "Menu",
    ["Home", "Breeds", "Diseases", "Feeding"]
)

if menu == "Home":
    st.write("This is home page")

elif menu == "Breeds":
    st.write("Murrah, Surti, Jaffarabadi")

elif menu == "Diseases":
    st.write("FMD, Mastitis")

elif menu == "Feeding":
    st.write("Feeding details here")
