<div align="center">
<br>
<img src="assets/nevadalogo.png" width="20%" />
<br>
M O R I A R T Y
<br>
</div>
<br>
<br>

1. [Info](#info)
2. [Prerequisites](#prerequisites)
3. [Installation & Usage](#installation--usage)
4. [Preview](#preview)
5. [Support](#support)

## Info

A high-performance x64 Assembly engine designed for in-memory file encryption and polymorphic obfuscation (Project III).

## Prerequisites
OS: Windows 10/11 (x64 Architecture).
Assembler: NASM (Netwide Assembler).
Linker: Microsoft Visual Studio Linker (link.exe) or GoLink.

## Installation & Usage
1. Download the `moriarty.asm` file and place it in your project folder.
2. Ensure you have a file named `target.bin` in the same directory (this is the file that will be encrypted).
3. Open your terminal or Command Prompt in the project folder.
4. Compile the source code into an object file:
```bash
nasm -f win64 moriarty.asm -o moriarty.obj
```
Link the object file to create the executable:
```bash
link /subsystem:console /entry:_start /out:moriarty.exe moriarty.obj kernel32.lib user32.lib
```
Execute the binary to start the encryption protocol:
```bash
.\moriarty.exe
```
The engine performs a Polymorphic XOR-Rotation on the target file, mutating the encryption key every 8 bytes to ensure high entropy and bypass static signature detection.
<small>W Y X N A R</small>
