; Name of the installer
Name "axonops-cqlsh"
OutFile "axonops-cqlsh-installer.exe"

; Default installation directory
InstallDir "$PROGRAMFILES\AxonOps"

; Request application privileges for Windows Vista/7/8/10
RequestExecutionLevel admin

; Interface Settings
ShowInstDetails show
ShowUninstDetails show

; Version Information
VIProductVersion "1.0.0.0"
VIAddVersionKey "ProductName" "AxonOps CQLSH"
VIAddVersionKey "CompanyName" "AxonOps"
VIAddVersionKey "FileVersion" "1.0.0.0"
VIAddVersionKey "ProductVersion" "1.0.0.0"
VIAddVersionKey "FileDescription" "AxonOps CQLSH Installer"
VIAddVersionKey "LegalCopyright" "© 2025 AxonOps"

; Sections define what to install
Section "Main Application"
    SetOutPath "$INSTDIR"
    
    ; Install main executable and required DLLs
    File "axonops-cqlsh.exe"
    File "c:\cygwin64\bin\cygwin1.dll"
    File "c:\cygwin64\bin\cygcrypto-*.dll"
    File "c:\cygwin64\bin\cygintl*.dll"
    File "c:\cygwin64\bin\libpython3.9.dll"
    File "c:\cygwin64\bin\cyggcc_s*.dll"
    File "c:\cygwin64\bin\cygz.dll"           ; Compression library
    File "c:\cygwin64\bin\cygssl-*.dll"       ; SSL support
    File "c:\cygwin64\bin\cygiconv-*.dll"     ; Character encoding
    File "c:\cygwin64\bin\cygncursesw-*.dll"  ; Terminal handling
    File "c:\cygwin64\bin\cygreadline*.dll"   ; Command line editing

    
    ; Install Python libraries
    File /r "build\lib.cygwin-3.6.1-x86_64-cpython-39\*"
    
    ; Include Python standard library
    SetOutPath "$INSTDIR\Lib"
    File /r "c:\cygwin64\lib\python3.9\*"

    ; Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    
    ; Create shortcuts (optional)
    CreateDirectory "$SMPROGRAMS\AxonOps"
    CreateShortcut "$SMPROGRAMS\AxonOps\axonops-cqlsh.lnk" "$INSTDIR\axonops-cqlsh.exe"
    CreateShortcut "$SMPROGRAMS\AxonOps\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"
    ; Remove all installed files
    Delete "$INSTDIR\axonops-cqlsh.exe"
    Delete "$INSTDIR\cygwin1.dll"
    Delete "$INSTDIR\cygcrypto-*.dll"
    Delete "$INSTDIR\cygz.dll"
    Delete "$INSTDIR\cygssl-*.dll"
    Delete "$INSTDIR\cygiconv-*.dll"
    Delete "$INSTDIR\cygncursesw-*.dll"
    Delete "$INSTDIR\cygreadline*.dll"
    Delete "$INSTDIR\libpython3.9.dll"
    Delete "$INSTDIR\cyggcc_s*.dll"
    Delete "$INSTDIR\cygintl*.dll"
    
    ; Remove Python libraries
    RMDir /r "$INSTDIR\Lib"
    RMDir /r "$INSTDIR\build"
        
    ; Remove shortcuts
    Delete "$SMPROGRAMS\AxonOps\axonops-cqlsh.lnk"
    Delete "$SMPROGRAMS\AxonOps\Uninstall.lnk"
    RMDir "$SMPROGRAMS\AxonOps"
    
    ; Remove uninstaller
    Delete "$INSTDIR\Uninstall.exe"
    
    ; Remove installation directory if empty
    RMDir "$INSTDIR"
SectionEnd

Section "Verify Installation"
    ; Check if the executable works
    ExecWait '"$INSTDIR\axonops-cqlsh.exe" --version' $0
    IntCmp $0 0 +3 0 0
    MessageBox MB_OK|MB_ICONSTOP "Installation verification failed. Please contact support."
    Abort
SectionEnd
