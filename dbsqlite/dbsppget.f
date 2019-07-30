      SUBROUTINE DBSPPGET (WK3, IPNT, ILIMIT)
      IMPLICIT NONE
C
C DBSQLITE $Id$
C
COMMONS
C
C
      INCLUDE 'DBSCOM.F77'
C
C
COMMONS
C
C
      INTEGER MXI
      PARAMETER (MXI=47)

      INTEGER INTS(MXI), ILIMIT, IPNT
      REAL    WK3(*)

      CALL IFREAD(WK3, IPNT, ILIMIT, INTS, MXI, 2)
      ISUMARY      = INTS(  1)
      ICOMPUTE     = INTS(  2)
      ITREELIST    = INTS(  3)
      IPOTFIRE     = INTS(  4)
      IFUELS       = INTS(  5)
      ITREEIN      = INTS(  6)
      ICUTLIST     = INTS(  7)
      IDM1         = INTS(  8)
      IDM2         = INTS(  9)
      IDM3         = INTS( 10)
      IDM5         = INTS( 11)
      IDM6         = INTS( 12)
      IFUELC       = INTS( 13)
      IBURN        = INTS( 14)
      IMORTF       = INTS( 15)
      ISSUM        = INTS( 16)
      ISDET        = INTS( 17)
      ISTRCLAS     = INTS( 18)
      IBMMAIN      = INTS( 19)
      IBMBKP       = INTS( 20)
      IBMTREE      = INTS( 21)
      IBMVOL       = INTS( 22)
      IDBSECON     = INTS( 23)
      ISPOUT6      = INTS( 24)
      ISPOUT17     = INTS( 25)
      ISPOUT21     = INTS( 26)
      ISPOUT23     = INTS( 27)
      ISPOUT30     = INTS( 28)
      ISPOUT31     = INTS( 29)
      IATRTLIST    = INTS( 30)
      I_CMPU       = INTS( 31)
      IADDCMPU     = INTS( 32)
      ICMRPT       = INTS( 33)
      ICHRPT       = INTS( 34)
      ICANPR       = INTS( 35)
      IRGIN        = INTS( 36)
      IDWDVOL      = INTS( 37)
      IDWDCOV      = INTS( 38)
      ! Make sure the databases are closed
      CALL DBSCLOSE(.TRUE.,.TRUE.)
      IF (INTS(39).EQ.1) IinDBref = -1 ! signal to reopen
      IF (INTS(40).EQ.1) IoutDBref= -1
      ICLIM        = INTS( 41)
      IRD1         = INTS( 42)
      IRD2         = INTS( 43)
      IRD3         = INTS( 44)
      ICALIB       = INTS( 45)
      ISTATS1      = INTS( 46)
      ISTATS2      = INTS( 47)

      CALL IFREAD(WK3, IPNT, ILIMIT, LENSTRINGS, 3, 2)
C
      RETURN
      END

      SUBROUTINE DBSCHGET (CBUFF, IPNT, LNCBUF)
      IMPLICIT NONE
C----------
C  **DBSCHGET--DBS DATE OF LAST REVISION: 05/14/2015
C----------
C
C
COMMONS
C
C
      INCLUDE 'DBSCOM.F77'
C
C
COMMONS
C
C
      INTEGER LNCBUF
      CHARACTER CBUFF(LNCBUF)
      INTEGER J,IPNT,KODE

      IF (LENSTRINGS(1).GT.0) THEN
        DO J=1,LENSTRINGS(1)
          CALL CHREAD(CBUFF,IPNT,LNCBUF,DSNIN(J:J),2)
        ENDDO
      ENDIF

      IF (LENSTRINGS(2).GT.0) THEN
        DO J=1,LENSTRINGS(2)
          CALL CHREAD(CBUFF,IPNT,LNCBUF,DSNOUT(J:J),2)
        ENDDO
      ENDIF

      IF (LENSTRINGS(3).GT.0) THEN
        DO J=1,LENSTRINGS(3)
          CALL CHREAD(CBUFF,IPNT,LNCBUF,KEYFNAME(J:J),2)
        ENDDO
      ENDIF

      DO J=1,36
        CALL CHREAD(CBUFF,IPNT,LNCBUF,CASEID(J:J),2)
      ENDDO

      ! reopen connections that were in use.

      IF (IinDBref.EQ.0) THEN
        IinDBref = -1
        CALL DBSOPEN(.FALSE.,.TRUE.,KODE)

        IF (KODE.EQ.0) PRINT *,"Reopen DBSIN failed. DSNIN=",
     -     TRIM(DSNIN)
      ENDIF
      IF (IoutDBref.EQ.0) THEN
        IoutDBref = -1
        CALL DBSOPEN(.TRUE.,.FALSE.,KODE)

        IF (KODE.EQ.0) PRINT *,"Reopen DSNOUT failed. DSNOUT=",
     -     TRIM(DSNOUT)
      ENDIF

      RETURN
      END
