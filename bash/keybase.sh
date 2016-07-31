# encrypt message "hola" for qrpnxz & ruffact only and store it in a list.out file
keybase pgp encrypt -m "hola" -o list.out qrpnxz ruffact

# encrypt file gastos.xlsx for ruffact only and store it
# as binary in a gastos.pgp.xlsx file
keybase pgp encrypt -b -i gastos.xlsx -o gastos.pgp.xlsx ruffact

# decrypt file Ruben.out and store it in Ruben.dec.docx
keybase pgp decrypt -i Ruben.out -o Ruben.dec.docx

# to encrypt large files,
# create a large key > 200 bits
# encripta T.mp4 & z.mp4 usando llave en prompt
# encrypt key using keybase
# send encrypted file & encrypted key to recipient

gpg2 -c T.mp4
gpg2 -c Z.mp4
