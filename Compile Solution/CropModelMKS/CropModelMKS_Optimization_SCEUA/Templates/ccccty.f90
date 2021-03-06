!
!  @GLOBAL.SOURCE@ - This module contains definitions of the @CLASS.NAME@ class
!
!  Generated by the Intel(R) Visual Fortran COM Server Wizard on
!  @GLOBAL.DATE@ at @GLOBAL.TIME@.
!
!   DO NOT EDIT THIS FILE!
!
!  This file is re-generated every time the object hierarchy is changed.
!

module @CLASS.NAME@_Types

    use @INSTANCETYPE.USE@
    use ifwinty

    !  Strings used in registering class
    character*@(= GetCStrLen(CLASS.DESCRIPTION)@), parameter :: @CLASS.NAME@_CLASS_NAME = ("@[@CLASS.DESCRIPTION@@]")
    character*@(= GetStrLen(CLASS.PROGID)@), parameter :: @CLASS.NAME@_PROGID = ("@CLASS.PROGID@")
    character*@(= GetStrLen(CLASS.VERSION)@),  parameter :: @CLASS.NAME@_VERSION = ("@{@CLASS.VERSION@@|1.0@}")
    character*@(= GetCStrLen(CLASS.THREADINGMODEL)@), parameter :: @CLASS.NAME@_THREADING_MODEL = ("@CLASS.THREADINGMODEL@")

    ! CLSIDs        
    type (guid), parameter :: CLSID_@CLASS.NAME@ = &
        @(= TypeGUID(CLASS.CLSID)@)
                                                
    ! IIDs      
    ! Per Interface
    @#PER INTERFACE
    type (guid), parameter :: IID_@INTERFACE.NAME@ = &
        @(= TypeGUID(INTERFACE.IID)@)
    @#ENDPER

    !  This is the per-instance data of the class
    ! Per Interface
    @#PER INTERFACE
    type @INTERFACE.NAME@_Ptr
        sequence
        type (@INTERFACE.NAME@_Vtbl), pointer :: pVtbl
        type (@CLASS.NAME@_InternalData), pointer :: pInternalData
    end type @INTERFACE.NAME@_Ptr
    @#ENDPER

    type @CLASS.NAME@_InternalData
        sequence
        type (@INSTANCETYPE.NAME@), pointer :: pInstanceData
        type (@CLASS.NAME@_Data), pointer :: pStart
        integer(SIZE_T) refCount
    end type @CLASS.NAME@_InternalData

    type @CLASS.NAME@_Data
        sequence
    ! Per Interface
        @#PER INTERFACE
        type (@INTERFACE.NAME@_ptr) @INTERFACE.NAME@_InternalData
        @#ENDPER
        type (@CLASS.NAME@_InternalData) InternalData
    end type @CLASS.NAME@_Data

    ! Per Interface
    !  All methods must return integer(LONG) (an HRESULT)
    !  All methods must take as their first argument, the instance
    !  data type by reference
    @#PER INTERFACE
    type @INTERFACE.NAME@_Vtbl
        sequence
        ! IUnknown Methods
        integer(INT_PTR_KIND()) QueryInterface
        integer(INT_PTR_KIND()) AddRef
        integer(INT_PTR_KIND()) Release
        @#IFTRUE DUAL
        ! IDispatch Methods
        integer(INT_PTR_KIND()) GetTypeInfoCount
        integer(INT_PTR_KIND()) GetTypeInfo
        integer(INT_PTR_KIND()) GetIDsOfNames
        integer(INT_PTR_KIND()) Invoke
        @#ENDIF
        !  @INTERFACE.NAME@ Methods
        @#PER METHOD
        integer(INT_PTR_KIND()) @METHOD.NAME@
        @#ENDPER
    end type @INTERFACE.NAME@_Vtbl
    @#ENDPER

  contains

    !  IUnknown implementation for all interfaces of the class

    function @CLASS.NAME@_QueryInterface (pData, riid, ppv) result (r)
        !dec$ attributes stdcall :: @CLASS.NAME@_QueryInterface
        use ifwinty
        use ifcom
        implicit none

        type (@INTERFACE.NAME@_Ptr) pData
        !dec$ attributes reference :: pData
        type(guid), intent(in) :: riid
        !dec$ attributes reference :: riid
        integer(int_ptr_kind()), intent(out) :: ppv
        !dec$ attributes reference :: ppv
        integer(long) r

        r = S_OK
        ppv = NULL

        !  Ensure that they are requesting a supported interface
        !  NOTE:  All requests for IUnknown MUST return the same pointer (per COM)
        if (COMIsEqualGUID(riid, IID_IUnknown)) then
            ppv = loc(pData % pInternalData % pStart % @INTERFACE.NAME@_InternalData)
        !  Per interface
        @#PER INTERFACE
        else if (COMIsEqualGUID(riid, IID_@INTERFACE.NAME@)) then
            ppv = loc(pData % pInternalData % pStart % @INTERFACE.NAME@_InternalData)
        @#IFTRUE DUAL
        else if (COMIsEqualGUID(riid, IID_IDispatch)) then
            ppv = loc(pData % pInternalData % pStart % @INTERFACE.NAME@_InternalData)
        @#ENDIF
        @#ENDPER
        end if

        if (ppv == NULL) then
            r = E_UNEXPECTED 
            return
        end if

        pData % pInternalData % refCount = &
            pData % pInternalData % refCount + 1

    end function 

    function @CLASS.NAME@_AddRef (pData) result (r)
        !dec$ attributes stdcall :: @CLASS.NAME@_AddRef
        use ifwinty
        implicit none

        type (@INTERFACE.NAME@_Ptr) pData
        !dec$ attributes reference :: pData
        integer r

        pData % pInternalData % refCount = &
            pData % pInternalData % refCount + 1
        r = pData % pInternalData % refCount

    end function 

    function @CLASS.NAME@_Release (pData) result (r)
        !dec$ attributes stdcall :: @CLASS.NAME@_Release
        use ifwinty
        use @GLOBAL.NAME@_global
        implicit none

        type (@INTERFACE.NAME@_Ptr) pData
        !dec$ attributes reference :: pData
        integer r

        type (@CLASS.NAME@_Data),  pointer :: p@CLASS.NAME@Data
        integer status

        pData % pInternalData % refCount = &
            pData % pInternalData % refCount - 1
        r = pData % pInternalData % refCount
        if (pData % pInternalData % refCount == 0) then
            !  Time to delete ourself....
            p@CLASS.NAME@Data => pData % pInternalData % pStart
            !  Call the "destructor"
            call @INSTANCETYPE.DESTRUCTOR@(p@CLASS.NAME@Data % InternalData % pInstanceData)
            !  Per interface
            @#PER INTERFACE
            deallocate (p@CLASS.NAME@Data % @INTERFACE.NAME@_InternalData % pVtbl)
            @#ENDPER
            deallocate (p@CLASS.NAME@Data % InternalData % pInstanceData)
            deallocate (p@CLASS.NAME@Data)
            status = ServerUnlock()
        end if

    end function 

    @#PER INTERFACE
    @#IFTRUE DUAL

    !  IDispatch implementation for @INTERFACE.NAME@

    function @CLASS.NAME@_GetTypeInfoCount(pData, pctinfo) result (hresult)
        !dec$ attributes stdcall :: @CLASS.NAME@_GetTypeInfoCount
        implicit none
        type (@INTERFACE.NAME@_Ptr) pData
        !dec$ attributes reference :: pData
        integer(long), intent(out) :: pctinfo
        !dec$ attributes reference :: pctinfo
        integer(long) hresult

        hresult = S_OK
        pctinfo = 1

    end function

    function @CLASS.NAME@_GetTypeInfo(pData, iTInfo, lcid, ppTInfo) result (hresult)
        !dec$ attributes stdcall :: @CLASS.NAME@_GetTypeInfo
        use ifwinty
        use @GLOBAL.NAME@_global
        use kernel32
        use oleaut32
        use ifcom
        implicit none
        type (@INTERFACE.NAME@_Ptr) pData
        !dec$ attributes reference :: pData
        integer, intent(in) :: iTInfo
        !dec$ attributes value :: iTInfo
        integer, intent(in) :: lcid
        !dec$ attributes value :: lcid
        integer(int_ptr_kind()), intent(out) :: ppTInfo
        !dec$ attributes reference :: ppTInfo
        integer(long) hresult

        interface
            function GetTypeInfoOfGuid(pITypeLib, rguid, ppTInfo) result (hresult)
                !dec$ attributes default :: GetTypeInfoOfGuid
                !dec$if defined(_X86_)
                !dec$ attributes stdcall, alias:'_GetTypeInfoOfGuid@8' :: GetTypeInfoOfGuid
                !dec$ else
                !dec$ attributes stdcall, alias:'GetTypeInfoOfGuid' :: GetTypeInfoOfGuid
                !dec$ endif
                use ifwinty
                integer(int_ptr_kind()) pITypeLib
                !dec$ attributes value :: pITypeLib
                TYPE (guid), intent(in) :: rguid 
                !dec$ attributes reference :: rguid
                integer(int_ptr_kind()), intent(out) :: ppTInfo
                !dec$ attributes reference :: ppTInfo
                integer(long) hresult
            end function
        end interface
        POINTER(GetTypeInfoOfGuid_PTR, GetTypeInfoOfGuid)	! routine pointer

        integer(int_ptr_kind()) pITypeLib    ! ITypeLib*
        integer(int_ptr_kind()) $VTBL		 ! ITypeLib Function Table
        pointer($VPTR, $VTBL)
        integer res

        hresult = S_OK
        if (iTInfo /= 0) then
            hresult = TYPE_E_ELEMENTNOTFOUND
            return
        end if
        ppTInfo = g@CLASS.NAME@ITypeInfo
        
        !  Get the type information if we don't already have it
        !  NOTE:  This code will always return the ITypeInfo of the
        !         first LCID that is found
        if (g@CLASS.NAME@ITypeInfo == NULL) then
            call EnterCriticalSection(loc(gGlobalCriticalSection))
            if (g@CLASS.NAME@ITypeInfo == NULL) then
                hresult = LoadRegTypeLib(GUID_TypeLib_@GLOBAL.NAME@, @{@(=GetVersionMajor(GLOBAL.TYPELIB_VERSION)@)@|1@}, @{@(=GetVersionMinor(GLOBAL.TYPELIB_VERSION)@)@|0@}, lcid, pITypeLib)
                if (hresult < 0) then
                    call LeaveCriticalSection(loc(gGlobalCriticalSection))
                    return
                end if
                $VPTR = pITypeLib
                $VPTR = $VTBL + (6 * INT_PTR_KIND()) ! Add GetTypeInfoOfGuid routine offset
                GetTypeInfoOfGuid_PTR = $VTBL
                hresult = GetTypeInfoOfGuid(pITypeLib, IID_@INTERFACE.NAME@, g@CLASS.NAME@ITypeInfo)
                res = COMReleaseObject(pITypelib)
                if (hresult < 0) then
                    call LeaveCriticalSection(loc(gGlobalCriticalSection))
                    return
                end if
            end if
            call LeaveCriticalSection(loc(gGlobalCriticalSection))
            ppTInfo = g@CLASS.NAME@ITypeInfo
        end if
        res = COMAddObjectReference(g@CLASS.NAME@ITypeInfo)

    end function

    function @CLASS.NAME@_GetIDsOfNames(pData, riid, rgszNames, cNames, lcid, rgDispID) result (hresult)
        !dec$ attributes stdcall :: @CLASS.NAME@_GetIDsOfNames
        use ifwinty
        use @GLOBAL.NAME@_global
        use ifcom
        implicit none
        type (@INTERFACE.NAME@_Ptr) pData
        !dec$ attributes reference :: pData
        type (guid), intent(in)    :: riid 
        !dec$ attributes reference :: riid
        integer(int_ptr_kind()), intent(in) :: rgszNames
        !dec$ attributes value :: rgszNames
        integer, intent(in) :: cNames
        !dec$ attributes value :: cNames
        integer, intent(in) :: lcid
        !dec$ attributes value :: lcid
        integer(long), dimension(:), intent(out) :: rgDispID
        !dec$ attributes reference :: rgDispID
        integer(long) hresult

        interface
            function DispGetIDsOfNames(pITypeInfo, rgszNames, cNames, rgDispID) result (hresult)
                !dec$ attributes default :: DispGetIDsOfNames
                !dec$if defined(_X86_)
                !dec$ attributes stdcall, alias:'_DispGetIDsOfNames@16' :: DispGetIDsOfNames
                !dec$ else
                !dec$ attributes stdcall, alias:'DispGetIDsOfNames' :: DispGetIDsOfNames
                !dec$ endif
                use ifwinty
                integer(int_ptr_kind()) pITypeInfo
                !dec$ attributes value :: pITypeInfo
                integer(int_ptr_kind()), intent(in) :: rgszNames
                !dec$ attributes value :: rgszNames
                integer, intent(in) :: cNames
                !dec$ attributes value :: cNames
                integer(long), dimension(:), intent(out) :: rgDispID
                !dec$ attributes reference :: rgDispID
                integer(long) hresult
            end function
        end interface

        type (guid), parameter :: IID_NULL = &
              guid(#00000000, #0000, #0000, &
                char('00'X)//char('00'X)//char('00'X)//char('00'X)// &
                char('00'X)//char('00'X)//char('00'X)//char('00'X))
        integer(int_ptr_kind()) pTInfo 
        integer res

        hresult = S_OK

        !  The riid argument must be IID_NULL
        if (.not. COMIsEqualGUID(riid, IID_NULL)) then
            hresult = DISP_E_UNKNOWNINTERFACE
            return
        end if

        !  Get the ITypeInfo pointer
        hresult = @CLASS.NAME@_GetTypeInfo(pData, 0, lcid, pTInfo)
        if (hresult < 0) return

        !  Call DispGetIDsOfNames
        hresult = DispGetIDsOfNames(pTInfo, rgszNames, cNames, rgDispID)
        res = COMReleaseObject(pTInfo)

    end function

    function @CLASS.NAME@_Invoke(pData, dispidMember, riid, lcid, &
        wFlags, pparams, pvarResult, pexcepinfo, puArgErr) result (hresult)
        !dec$ attributes stdcall :: @CLASS.NAME@_Invoke
        use ifwinty
        use @GLOBAL.NAME@_global
        use ifcom
        implicit none
        type (@INTERFACE.NAME@_Ptr) pData
        !dec$ attributes reference :: pData
        integer(long), intent(in) :: dispidMember
        !dec$ attributes value :: dispidMember
        type (guid), intent(in)    :: riid 
        !dec$ attributes reference :: riid
        integer, intent(in) :: lcid
        !dec$ attributes value :: lcid
        integer(2), intent(in) :: wFlags
        !dec$ attributes value :: wFlags
        type(T_DISPPARAMS), intent(inout) :: pparams
        !dec$ attributes reference :: pparams
        type(VARIANT), intent(out) :: pvarResult
        !dec$ attributes reference :: pvarResult
        type(T_EXCEPINFO), intent(out) :: pexcepinfo
        !dec$ attributes reference :: pexcepinfo
        integer, intent(out) :: puArgErr
        !dec$ attributes reference :: puArgErr
        integer(long) hresult

        interface
            function DispInvoke(pInterface, pTInfo, dispidMember, &
                wFlags, pparams, pvarResult, pexcepinfo, puArgErr) result (hresult)
                !dec$ attributes default :: DispInvoke
                !dec$if defined(_X86_)
                !dec$ attributes stdcall, alias:'_DispInvoke@32' :: DispInvoke
                !dec$ else
                !dec$ attributes stdcall, alias:'DispInvoke' :: DispInvoke
                !dec$ endif
                use ifwinty
                integer(int_ptr_kind()) pInterface
                !dec$ attributes value :: pInterface
                integer(int_ptr_kind()) pTInfo
                !dec$ attributes value :: pTInfo
                integer(long), intent(in) :: dispidMember
                !dec$ attributes value :: dispidMember
                integer(2), intent(in) :: wFlags
                !dec$ attributes value :: wFlags
                type(T_DISPPARAMS), intent(inout) :: pparams
                !dec$ attributes reference :: pparams
                type(VARIANT), intent(out) :: pvarResult
                !dec$ attributes reference :: pvarResult
                type(T_EXCEPINFO), intent(out) :: pexcepinfo
                !dec$ attributes reference :: pexcepinfo
                integer, intent(out) :: puArgErr
                !dec$ attributes reference :: puArgErr
                integer(long) hresult
            end function
        end interface

        type (guid), parameter :: IID_NULL = &
               guid(#00000000, #0000, #0000, &
                 char('00'X)//char('00'X)//char('00'X)//char('00'X)// &
                 char('00'X)//char('00'X)//char('00'X)//char('00'X))
        integer(int_ptr_kind()) pTInfo 
        integer res

        hresult = S_OK

        !  The riid argument must be IID_NULL
        if (.not. COMIsEqualGUID(riid, IID_NULL)) then
            hresult = DISP_E_UNKNOWNINTERFACE
            return
        end if

        !  Get the ITypeInfo pointer
        hresult = @CLASS.NAME@_GetTypeInfo(pData, 0, lcid, pTInfo)
        if (hresult < 0) return

        !  Call DispInvoke
        hresult = DispInvoke(loc(pdata), pTInfo, dispidMember, &
                wFlags, pparams, pvarResult, pexcepinfo, puArgErr)
        res = COMReleaseObject(pTInfo)

    end function
    @#ENDIF
    @#ENDPER

end module

@($INSTANCENAME = CopyStr(INSTANCETYPE.NAME)@)
@#PER INTERFACE
@#template "ccccim.f90|@INTERFACE.NAME@.f90"
@#ENDPER
