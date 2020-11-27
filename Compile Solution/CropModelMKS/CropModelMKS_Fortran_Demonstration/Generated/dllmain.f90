!
!  dllmain.f90 - This file contains the exported functions that are
!  required for COM Server DLLs
!
!  Generated by the Intel(R) Visual Fortran COM Server Wizard on
!  11/19/20 at 12:32:32.
!
!   DO NOT EDIT THIS FILE!
!
!  This file is re-generated every time the object hierarchy is changed.
!

!
!  E X P O R T E D   F U N C T I O N S
! 

!********************************************************************
!   ROUTINE: DllMain(HANDLE, DWORD, LPVOID)
!
!   PURPOSE:  DllMain is called by Windows when
!     the DLL is initialized, Thread Attached, and other times.
!     Refer to SDK documentation, as to the different ways this
!     may be called.
!
!     The DllMain function should perform additional initialization
!     tasks required by the DLL.  DllMain should return a value of 1
!     if the initialization is successful.
!
!*********************************************************************

integer(4) function DllMain (hInst, ul_reason_being_called, lpReserved)
    !dec$ if defined(_X86_)
    !dec$ attributes dllexport, stdcall, alias : '_DllMain@12' :: DllMain
    !dec$ else
    !dec$ attributes dllexport, stdcall, alias : 'DllMain' :: DllMain
    !dec$ end if
    use CropModelMKS_Fortran_Demonstration_global
    use ifcom
    implicit none

    ! Arguments
    integer(HANDLE) hInst
    integer(DWORD) ul_reason_being_called
    integer(LPVOID) lpReserved

    ! Variables
    integer(4) status

    if (ul_reason_being_called == DLL_PROCESS_ATTACH) then
      !  Save the module instance handle in a global variable
        ghinst =  hInst
        gCntLock = 0
        call InitializeCriticalSection(loc(gGlobalCriticalSection))
        ! Per Class
        gComponentIClassFactory = NULL
        gComponentITypeInfo = NULL
    else if (ul_reason_being_called == DLL_PROCESS_DETACH) then
        ! Release any class factories
        ! Per Class
        if (gComponentIClassFactory /= NULL) then
            status = COMReleaseObject(gComponentIClassFactory)    
        end if
        if (gComponentITypeInfo /= NULL) then
            status = COMReleaseObject(gComponentITypeInfo)    
        end if
        call DeleteCriticalSection(loc(gGlobalCriticalSection))
    end if

    !  Return 1 to indicate success
    DllMain = 1
    return

end function DllMain

!********************************************************************
!   ROUTINE: DllRegisterServer(VOID)
!
!   PURPOSE:  DllRegisterServer is called to have the DLL
!             register itself.  
!
!*********************************************************************

function DllRegisterServer () result (r)
    !dec$ if defined(_X86_)
    !dec$ attributes stdcall, alias : '_DllRegisterServer@0' :: DllRegisterServer
    !dec$ else
    !dec$ attributes stdcall, alias : 'DllRegisterServer' :: DllRegisterServer
    !dec$ end if
    use ifwinty
    use serverhelper
    implicit none

    integer(LONG) r

    r = RegisterServer()
    return
end function DllRegisterServer

!********************************************************************
!   ROUTINE: DllUnregisterServer(VOID)
!
!   PURPOSE:  DllUnregisterServer is called to have the DLL
!             remove its registration information.  
!
!*********************************************************************

function DllUnregisterServer () result (r)
    !dec$ if defined(_X86_)
    !dec$ attributes stdcall, alias : '_DllUnregisterServer@0' :: DllUnregisterServer
    !dec$ else
    !dec$ attributes stdcall, alias : 'DllUnregisterServer' :: DllUnregisterServer
    !dec$ end if
    use ifwinty
    use serverhelper
    implicit none

    integer(long) r

    r = UnregisterServer()
    return
end function DllUnregisterServer

!********************************************************************
!   ROUTINE: DllGetClassObject(rclsid, riid, ppv)
!
!   PURPOSE:  DllGetClassObject is called to have the DLL create an
!             instance of a class supported by the server.  
!
!*********************************************************************

function DllGetClassObject (rclsid, riid, ppv) result (r)
    !dec$ if defined(_X86_)
    !dec$ attributes stdcall, alias : '_DllGetClassObject@12' :: DllGetClassObject
    !dec$ else
    !dec$ attributes stdcall, alias : 'DllGetClassObject' :: DllGetClassObject
    !dec$ end if
    use CropModelMKS_Fortran_Demonstration_global
    use Component_Types
    use IClassFactory_Types
    use IClassFactory_Methods
    use ifwinty
    use ifcom
    implicit none

    type(guid) rclsid
    !dec$ attributes reference :: rclsid
    type(guid) riid
    !dec$ attributes reference :: riid
    integer(int_ptr_kind()) ppv
    !dec$ attributes reference :: ppv
    integer(long) r

    integer(long) status

    r = S_OK
    ppv = NULL

    !  Ensure that they are requesting a supported class and
    !  the IClassFactory or IUnknown interface
    if ((.not. COMIsEqualGUID(riid, IID_IClassFactory)) .AND. &
        (.not. COMIsEqualGUID(riid, IID_IUnknown))) then
        r = E_UNEXPECTED 
        return
    end if
    !  Per class - Create the class factory, if necessary
    if (COMIsEqualGUID(rclsid, CLSID_Component)) then
        if (gComponentIClassFactory == NULL) then
            call EnterCriticalSection(loc(gGlobalCriticalSection))
            if (gComponentIClassFactory == NULL) then
                !  Allocate an instance data structure and a Vtbl
                allocate (gpComponentCFData)
                allocate (gpComponentCFData % pVtbl)
                gpComponentCFData % refCount = 1
                !  The Vtbl implementations are in ClsFact.f90
                gpComponentCFData % pVtbl % QueryInterface = &
                        loc(IClassFactory_QueryInterface)
                gpComponentCFData % pVtbl % AddRef = &
                        loc(IClassFactory_AddRef)
                gpComponentCFData % pVtbl % Release = &
                        loc(IClassFactory_Release)
                gpComponentCFData % pVtbl % CreateInstance = &
                        loc(IClassFactory_CreateComponentInstance)
                gpComponentCFData % pVtbl % LockServer = &
                        loc(IClassFactory_LockServer)
                gComponentIClassFactory  = loc(gpComponentCFData)
            end if
            call LeaveCriticalSection(loc(gGlobalCriticalSection))
        end if
        ppv = loc(gpComponentCFData)
        status = COMAddObjectReference (ppv) 
        return
    end if

    r = CLASS_E_CLASSNOTAVAILABLE 
    return

end function DllGetClassObject

!********************************************************************
!   ROUTINE: DllCanUnloadNow(VOID)
!
!   PURPOSE:  DllCanUnloadNow is called to check whether the DLL
!             can be unloaded
!
!*********************************************************************

function DllCanUnloadNow () result (r)
    !dec$ if defined(_X86_)
    !dec$ attributes stdcall, alias : '_DllCanUnloadNow@0' :: DllCanUnloadNow
    !dec$ else
    !dec$ attributes stdcall, alias : 'DllCanUnloadNow' :: DllCanUnloadNow
    !dec$ end if
    use ifwinty
    use CropModelMKS_Fortran_Demonstration_global
    implicit none

    integer(LONG) r

    if (gCntLock > 0) then
        r = S_FALSE         ! "No"
    else
        r = S_OK            ! "Yes"
    endif

    return

end function DllCanUnloadNow