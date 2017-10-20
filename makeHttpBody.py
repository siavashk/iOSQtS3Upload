def main():
    with open('test.bin', mode='rb') as binary:
        binaryContent = binary.read()
        with open('test_processed.bin', mode='a') as file:
            file.write("\r\n")
        with open('test_processed.bin', mode='ab') as file:
            file.write(binaryContent)
        with open('test_processed.bin', mode='a') as file:
            file.write("\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--")

if __name__ == "__main__":
    main()
