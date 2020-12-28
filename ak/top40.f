      SUBROUTINE TOP40(TIME,SSITE,ISISP,RTOP40)
      IMPLICIT NONE
C----------
C AK $Id$
C----------
C THIS ROUTINE CALCULATES THE APPROX TOP HT FOR NEWLY ESTABISHED TREES
C IN ESTAB.  TIME IS THE TIME SINCE DISTURBANCE. SITE IS THE FARR SITE.
C ISISP IS SITE SPECIES CODE 1 TO 13.  NO ALLOWANCE IS MADE FOR ADVANCE
C REGEN. TIME IS ADJUSTED TO BHAGE SO FARR HT GROWTH EQUATIONS CAN BE US
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
COMMONS
C
C----------
C  VARIABLE DECLARATIONS:
C----------
C
      LOGICAL DEBUG
C
      INTEGER ISISP
C
      REAL B0,B1,B2,B3,BHAGE,BHAGLN,C0,C1,C2,C3,HB,HEIGHT,PH
      REAL RTOP40,SSITE,TIME,TTBH,X5,X6
C
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'TOP40',5,ICYC)
      IF(DEBUG) WRITE(JOSTND,3)ICYC
    3 FORMAT(' ENTERING SUBROUTINE TOP40  CYCLE =',I5)
C
      IF(TIME .EQ. 0.0)GO TO 1000
      TTBH = 16.7 - 0.12*SSITE
      BHAGE=TIME-TTBH
      IF(BHAGE .LE. 0.)THEN
          RTOP40=4.5*TIME/TTBH
          BHAGE=0.0
          GO TO 1100
      ELSE
          IF(ISISP .LE. 13)THEN
          BHAGLN=ALOG(BHAGE)
          X5 = -0.2050542 + 1.449615*BHAGLN -
     &    0.01780992*(BHAGLN)**3 + 6.519748E-5*BHAGLN**5
     &    -1.095593E-23*(BHAGLN**30)
          X6 = -5.6118790 + 2.418604*BHAGLN -0.259311*(BHAGLN**2)
     &    + 1.351445E-4*(BHAGLN**5) - 1.701139E-12*(BHAGLN**16)
     &     + 7.964197E-27*(BHAGLN**36)
          RTOP40 = 4.5 + EXP(X5) - EXP(X6)*86.43 + EXP(X6)*(SSITE-4.5)
      ELSE
          IF(BHAGE .LE. 0.0)RTOP40=4.5-0.9758+0.2384*(SSITE-4.5)
          IF(BHAGE .GT. 0.0 .AND. BHAGE .LE. 25)RTOP40=
     &    4.5 - 2.6963 + 0.4873*(SSITE-4.5)
          IF(BHAGE .GT. 25)RTOP40=4.5-3.4674+0.7075*(SSITE-4.5)
      END IF
      END IF
      GO TO 1100
 1000 CONTINUE
               HEIGHT = RTOP40
               B0 = 3.380276
               B1 = 0.8683028
               B2 = 0.01630621
               B3 = 2.744017*SSITE**(-0.2095425)
               C0 = (1 - EXP(-10.*B2))*B0**(1/B3)
               C1 = B1/B3
               C2 = EXP(-10.*B2)
               C3 = 1/B3
               HB = HEIGHT- 4.5
               PH = 4.5 + (C0*SSITE**C1 + C2*HB**C3)**(1/C3) - HB
C----------
C FARR SITE CURVES ARE FOR BH AGE SO APPROXIMATE WHAT HTG WOULD BE
C FOR DOMINANT SMALL TREES.
C----------
      IF(HB .LE. 0.0)PH=10.0
      RTOP40=RTOP40 + PH
 1100 IF(DEBUG)WRITE(JOSTND,10)ICYC
   10 FORMAT(' LEAVING SUBROUTINE TOP40  CYCLE =',I5)
      IF(DEBUG)WRITE(JOSTND,*)' TIME,SSITE,ISISP,RTOP40= ',
     &TIME,SSITE,ISISP,RTOP40
      RETURN
      END