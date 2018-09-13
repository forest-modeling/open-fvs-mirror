      SUBROUTINE KEYOPN (IREAD,RECORD,JOSTND,IRECNT,KEYWRD,
     >                   ARRAY,KARD)
      IMPLICIT NONE
C----------
C CANADA-BC $Id$
C----------
C
C     PROCESSES THE OPEN KEYWORD.
C
C     ARGUMENTS:
C     IREAD =THE KEYWORD READER DATA SET REFERENCE NUMBER.
C     RECORD=CHARACTER RECORD BUFFER.
C     JOSTND=STANDARD OUTPUT FILE NUMBER.
C     IRECNT=RECORD COUNTER NUMBER.
C     KEYWRD=KEYWORD.
C     ARRAY =PARAMETERS.
C     KARD  =CHAR*10... THE FILEDS.
C
      INTEGER IRECNT,JOSTND,IREAD,IM,IUNIT,IZNUL,IS,IFORM,IRLEN,I,KODE
      INTEGER IRTNCD
      REAL ARRAY(7)
      CHARACTER RECORD*(*),KARD(7)*10,KEYWRD*8,CSTAT*7,CFOUR*4
      CHARACTER EXTENSION*3      
      IM=0
C
      READ (IREAD,'(A)',END=80) RECORD
      IRECNT=IRECNT+1
      IF (ARRAY(1).LE.0.0) THEN
         CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
         CALL ERRGRO (.TRUE.,4)
         RETURN
      ENDIF
      IUNIT=IFIX(ARRAY(1))
      IF (ARRAY(2).EQ.0) THEN
         IZNUL=0
         CFOUR='ZERO'
      ELSE
         IZNUL=1
         CFOUR='NULL'
      ENDIF
      IS=ARRAY(3)+1
      IF (IS.LE.0.OR.IS.GT.4) THEN
         CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
         CALL ERRGRO (.TRUE.,4)
         RETURN
      ENDIF
      IF (IS.EQ.1) CSTAT='UNKNOWN'
      IF (IS.EQ.2) CSTAT='NEW'
      IF (IS.EQ.3) CSTAT='OLD'
      IF (IS.EQ.4) THEN
         CSTAT='FRESH'
         IS=5
      ENDIF
      IF (ARRAY(4).GT.0) IM=ARRAY(4)
      IFORM=1
      IF (ARRAY(5).GT.0) IFORM=2
      IF(IFORM .EQ. 1 .AND. IM .LT. 150) IM=150
      CALL UNBLNK (RECORD,IRLEN)
C----------
C  FORCE .KCP OR .ADD FILES TO USE IS=3 (CSTAT='OLD') SO OPEN ERROR
C  IS GENERATED WHEN FILE DOES NOT EXIST
C----------
      EXTENSION='   '
      DO I= IRLEN,2,-1
        IF (RECORD(I-1:I-1).EQ. '.') THEN
          EXTENSION=RECORD(I:I+2)
          GO TO 10
        END IF
      END DO
   10 CONTINUE
      IF((EXTENSION.EQ.'KCP').OR.(EXTENSION.EQ.'ADD'))IS=3
C
C     CALL MYOPEN TO OPEN THE FILE.  MACHINE SPECIFIC CODE IS IN MYOPEN
C
!     CALL MYOPEN (IUNIT,RECORD,IS,IM,IZNUL,IFORM,1,0,KODE) ! US style
      CALL MYOPEN (IUNIT,RECORD,IS,IM,IZNUL,IFORM,1,1,KODE) ! BC/ON style
C
      WRITE (JOSTND,40) KEYWRD,IUNIT,CFOUR,CSTAT,IM,IFORM,
     >                  RECORD(1:IRLEN)
   40 FORMAT (/1X,A8,'   DATA SET REFERENCE NUMBER = ',I5,'; BLANK=',A4,
     >       '; STATUS=',A7/T13,
     >       'MAXIMUM RECORD LENGTH (IGNORED ON SOME MACHINES) =',I4,
     >       '; FILE FORM=',I2,' (1=FORMATTED, 2=UNFORMATTED)',
     >       /T13,'DATA SET NAME = ',A)
C
      IF(((KODE.EQ.1).AND.(EXTENSION.EQ.'KCP')).OR.
     &  ((KODE.EQ.1).AND.(EXTENSION.EQ.'ADD'))) THEN
        CALL ERRGRO(.TRUE.,31)
      ELSE IF (KODE.EQ.1)THEN
        WRITE (JOSTND,50)
      ENDIF
   50 FORMAT (/T13,'**********   OPEN FAILED   **********')
      RETURN
   80 CONTINUE
      CALL ERRGRO (.FALSE.,2)
      CALL fvsGetRtnCode(IRTNCD)
      IF (IRTNCD.NE.0) RETURN
      
      RETURN
      END
