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
    File "axonops-cqlsh.exe"
    File "c:\python311\python311.dll"
    
    ; Include Visual C++ Runtime DLLs as fallback
    File "c:\python311\vcruntime140.dll"
    File "c:\python311\vcruntime140_1.dll"
    File "c:\Windows\System32\msvcp140.dll"
    
    ; Install Python libraries
    SetOutPath "$INSTDIR\Lib"
    File /r "c:\python311\Lib\json"

    File /r "c:\python311\Lib\_compat_pickle.py"
    File /r "c:\python311\Lib\stringprep.py"
    File /r "c:\python311\Lib\_weakrefset.py"
    File /r "c:\python311\Lib\argparse.py"
    File /r "c:\python311\Lib\ast.py"
    File /r "c:\python311\Lib\asyncore.py"
    File /r "c:\python311\Lib\base64.py"
    File /r "c:\python311\Lib\bisect.py"
    File /r "c:\python311\Lib\cProfile.py"
    File /r "c:\python311\Lib\calendar.py"
    File /r "c:\python311\Lib\cmd.py"
    File /r "c:\python311\Lib\configparser.py"
    File /r "c:\python311\Lib\contextlib.py"
    File /r "c:\python311\Lib\copy.py"
    File /r "c:\python311\Lib\copyreg.py"
    File /r "c:\python311\Lib\csv.py"
    File /r "c:\python311\Lib\dataclasses.py"
    File /r "c:\python311\Lib\datetime.py"
    File /r "c:\python311\Lib\decimal.py"
    File /r "c:\python311\Lib\dis.py"
    File /r "c:\python311\Lib\enum.py"
    File /r "c:\python311\Lib\fnmatch.py"
    File /r "c:\python311\Lib\functools.py"
    File /r "c:\python311\Lib\getpass.py"
    File /r "c:\python311\Lib\gettext.py"
    File /r "c:\python311\Lib\glob.py"
    File /r "c:\python311\Lib\hashlib.py"
    File /r "c:\python311\Lib\heapq.py"
    File /r "c:\python311\Lib\inspect.py"
    File /r "c:\python311\Lib\ipaddress.py"
    File /r "c:\python311\Lib\keyword.py"
    File /r "c:\python311\Lib\linecache.py"
    File /r "c:\python311\Lib\locale.py"
    File /r "c:\python311\Lib\nturl2path.py"
    File /r "c:\python311\Lib\numbers.py"
    File /r "c:\python311\Lib\opcode.py"
    File /r "c:\python311\Lib\operator.py"
    File /r "c:\python311\Lib\pathlib.py"
    File /r "c:\python311\Lib\pickle.py"
    File /r "c:\python311\Lib\platform.py"
    File /r "c:\python311\Lib\profile.py"
    File /r "c:\python311\Lib\pstats.py"
    File /r "c:\python311\Lib\queue.py"
    File /r "c:\python311\Lib\quopri.py"
    File /r "c:\python311\Lib\random.py"
    File /r "c:\python311\Lib\reprlib.py"
    File /r "c:\python311\Lib\selectors.py"
    File /r "c:\python311\Lib\shlex.py"
    File /r "c:\python311\Lib\shutil.py"
    File /r "c:\python311\Lib\signal.py"
    File /r "c:\python311\Lib\socket.py"
    File /r "c:\python311\Lib\ssl.py"
    File /r "c:\python311\Lib\string.py"
    File /r "c:\python311\Lib\struct.py"
    File /r "c:\python311\Lib\subprocess.py"
    File /r "c:\python311\Lib\tempfile.py"
    File /r "c:\python311\Lib\textwrap.py"
    File /r "c:\python311\Lib\threading.py"
    File /r "c:\python311\Lib\token.py"
    File /r "c:\python311\Lib\tokenize.py"
    File /r "c:\python311\Lib\traceback.py"
    File /r "c:\python311\Lib\types.py"
    File /r "c:\python311\Lib\typing.py"
    File /r "c:\python311\Lib\uuid.py"
    File /r "c:\python311\Lib\warnings.py"
    File /r "c:\python311\Lib\weakref.py"
    File /r "c:\python311\Lib\webbrowser.py"
    File /r "c:\python311\Lib\zipfile.py"

    File /r "c:\python311\Lib\encodings"
    File /r "c:\python311\Lib\backports"
    File /r "c:\python311\Lib\collections"
    File /r "c:\python311\Lib\concurrent"
    File /r "c:\python311\Lib\ctypes"
    File /r "c:\python311\Lib\email"
    File /r "c:\python311\Lib\html"
    File /r "c:\python311\Lib\http"
    File /r "c:\python311\Lib\importlib"
    File /r "c:\python311\Lib\logging"
    File /r "c:\python311\Lib\multiprocessing"
    File /r "c:\python311\Lib\pydoc_data"
    File /r "c:\python311\Lib\re"
    File /r "c:\python311\Lib\pydoc_data"
    File /r "c:\python311\Lib\urllib"
    File /r "c:\python311\Lib\xml"
    File /r "c:\python311\Lib\xmlrpc"
    File /r "c:\python311\Lib\zoneinfo"

    File /r "c:\python311\DLLs\_*.pyd"
    File /r "c:\python311\DLLs\pyexpat.pyd"
    File /r "c:\python311\DLLs\select.pyd"
    File /r "c:\python311\DLLs\unicodedata.pyd"
    File /r "c:\python311\DLLs\libcrypto-3.dll"
    File /r "c:\python311\DLLs\libssl-3.dll"

    File /r "build\lib.win-amd64-cpython-311\cassandra"
    File /r "build\lib.win-amd64-cpython-311\cqlshlib"
    File /r "build\lib.win-amd64-cpython-311\wcwidth"
    File /r "build\lib.win-amd64-cpython-311\cqlsh_main*.pyd"
    
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
    Delete "$INSTDIR\python311.dll"
    Delete "$INSTDIR\vcruntime140.dll"
    Delete "$INSTDIR\msvcp140.dll"
    Delete "$INSTDIR\vcruntime140_1.dll"
    
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
