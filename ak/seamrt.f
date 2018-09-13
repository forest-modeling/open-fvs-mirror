      SUBROUTINE SEAMRT(TOKILL,DEBUG,SUMKIL)
      IMPLICIT NONE
C----------
C AK $Id$
C----------
C SUBROUTINE TO DISTRIBUTE MORTALITY ACCORDING TO PERCENTILE AND
C SPECIES TOLERANCE.
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'COEFFS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'ESTREE.F77'
C
C
      INCLUDE 'MULTCM.F77'
C
C
      INCLUDE 'OUTCOM.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
      INCLUDE 'PLOT.F77'
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
      INTEGER I,IG,ISWTCH,JPASS,JSPC,MINSTP,NPASS
C
      REAL ADJUST,CRI,OTEM2,PASS1,PEFF,SHORT,SUMKIL,TEMKIL,TEMSUM
      REAL TOKILL,TPALFT,XKILL
C
      REAL EFFTR(MAXTRE),TEMWK2(MAXTRE),VARADJ(MAXSP)
C
C----------
C  DATA STATEMENTS:
C
C  SPECIES ORDER
C  1    2    3    4    5    6    7    8    9   10   11  12  13
C WS  WRC  PSF   MH   WH  AYC   LP   SS   SAF  RA   CW  OH  OS
C----------
      DATA VARADJ/ 0.500, 0.100, 0.300, 0.300, 0.100,
     &             0.300, 0.700, 0.300, 0.100, 0.500,
     &             0.900, 0.500, 0.700/
C----------
C  VARIABLE DEFINITIONS:
C   ADJUST = FINAL SCALAR ADJUSTMENT NEEDED TO SCALE MORTALITY VALUES
C            TO ACHIEVE THE DESIRED MORTALITY LEVEL
C    SHORT = TPA SHORT OF REACHING THE DESIRED MORTALITY LEVEL (DUE TO
C            ALL THE TREE'S PROB BEING ATTRIBUTED TO MORTALITY BEFORE THE 
C            DESIRED STAND LEVEL MORTALITY LEVEL IS REACHED)
C   TOKILL = NUMBER OF TREES TO KILL THIS CYCLE
C   SUMKIL = RUNNING TOTAL OF NUMBER OF TREES KILLED SO FAR
C    PASS1 = NUMBER OF TREES KILLED IN ONE PASS THROUGH THE TREELIST
C            WITH THE SPECIFIED TREE LEVEL MORTALITY EFFICIENCIES
C   VARADJ = TREE SHADE TOLERANCE (1.0 = MOST INTOLERANT)
C    JPASS = VARIABLE TO TRACK THE NUMBER OF PASSES THROUGH THE LOGIC
C   TPALFT = DIFFERENCE BETWEEN INITIAL TPA AND MORTALITY TPA
C----------
      IF(DEBUG)WRITE(JOSTND,20)ICYC,TOKILL
   20 FORMAT('0ENTERING VARMRT CYCLE =',I3,' DENSITY RELATED TOKILL = ',
     &F6.1)
C----------
C DETERMINE TOTAL NUMBER OF TREES TO KILL IF BACKGROUND MORTALITY
C IS STILL IN EFFECT
C----------
      IF(TOKILL .EQ. 0.0) THEN
        DO I=1,ITRN
          TOKILL = TOKILL+WK2(I)
        ENDDO
        IF(DEBUG)WRITE(JOSTND,*)' BACKGROUND TOKILL = ',TOKILL
      ENDIF
C----------
C INITIALIZE SCALARS AND ARRAYS
C----------
      TEMKIL=TOKILL
      JPASS=0
      PASS1=0.
      SUMKIL=0.
      DO I=1,ITRN
        WK2(I)=0.
        TEMWK2(I)=0.
        EFFTR(I)=0.
      ENDDO
C----------
C PASS THROUGH THE TREELIST AND LOAD MORTALITY EFFICIENCY VALUES FOR
C EACH TREE RECORD.
C CALCULATE HOW MANY TPA WILL BE KILLED IN ONE PASS THROUGH THE TREELIST
C WITH EFFICIENCY VALUES SET AT THIS LEVEL.
C----------
      DO I=1,ITRN
        JSPC=ISP(I)
        CRI = REAL(ICR(I))
        PEFF = 0.84525 - 0.01074*PCT(I) + 0.0000002*PCT(I)**3.0
        IF(PEFF .GT. 1.0) PEFF = 1.0
        IF(PEFF .LT. 0.01) PEFF = 0.01
        EFFTR(I) = PEFF * ((100.-CRI)/100.) * VARADJ(JSPC) * 0.01
        PASS1 = PASS1 + PROB(I)*EFFTR(I)
      ENDDO    
      IF(DEBUG)WRITE(JOSTND,30)ITRN,(EFFTR(IG),IG=1,ITRN)
   30 FORMAT(' MORTALITY EFFICIENCY VALUES, ITRN = ',I7,
     &(/10F10.5))
      IF(DEBUG)WRITE(JOSTND,*)' TREES KILLED IN ONE PASS = ',PASS1
C----------
C  CALCULATE THE APPROXIMATE NUMBER OF PASSES NEEDED TO ACHIEVE THE
C  DESIRED MORTALITY
C----------
      NPASS = INT(TOKILL/PASS1)+1
      IF(DEBUG)WRITE(JOSTND,*)' APPROXIMATE NUMBER OF PASSES NEEDED = ',
     &NPASS
C----------
C  LOOP THROUGH THE TREES AND LOAD THE FIRST GUESS AT TREE RECORD
C  MORTALITY BASED ON THE MORTALITY EFFICIENCY (r) AND APPROXIMATE NUMBER
C  OF PASSES NEEDED (n). THIS IS A GEOMETRIC PROGRESSION WHERE THE RATE
C  IS THE MORTALITY EFFICIENCY (r) AND THE STARTING VALUE IS THE INITIAL
C  PROB VALUE (a). THE Nth TERM IN THE PROGRESSION IS a*r*(1-r)**(n-1)
C  AND THE SUM OF N TERMS IS -a*((1-r)**n - 1)
C  ACCUMULATE THE MORTALITY ACHIEVED WITH THIS FIRST PASS
C----------
  100 CONTINUE
      JPASS=JPASS+1
      IF(JPASS .GT. 1)TEMKIL=SHORT
      ISWTCH=0
  105 CONTINUE
      TEMSUM=0.
      DO I=1,ITRN
        TPALFT = PROB(I)-WK2(I)
        IF(TPALFT .GT. 0.)THEN
          OTEM2 = TEMWK2(I)
          TEMWK2(I) = (-TPALFT*((1.0-EFFTR(I))**NPASS - 1.0))
          IF(DEBUG)WRITE(JOSTND,*)' I,PROB,WK2,TPALFT,EFFTR,TEMWK2,',
     &    'OTEM2= ',I,PROB(I),WK2(I),TPALFT,EFFTR(I),TEMWK2(I),OTEM2
          TEMSUM=TEMSUM+TEMWK2(I)
        ENDIF
      ENDDO
      IF(DEBUG)WRITE(JOSTND,*)' AFTER GUESS ',JPASS,' TEMSUM= ',TEMSUM,
     &'  TOKILL= ',TOKILL
C----------
C ADJUST MORTALITY VALUES TO ACHIEVE DESIRED MORTALITY
C IF AN ENTIRE TREE RECORD PROB GETS KILLED, ADJUST PASS1 VALUE FOR
C THE NEXT PASS
C----------
      IF(NPASS .GT. 50)THEN
        MINSTP=5
      ELSEIF(NPASS .GT. 20)THEN
        MINSTP=2
      ELSE
        MINSTP=1
      ENDIF
      ADJUST=TEMKIL/TEMSUM
      IF(ADJUST .LT. 0.8)THEN
        IF(ISWTCH .EQ. 2) GO TO 110
        IF(DEBUG)WRITE(JOSTND,*)' TEMKIL,TEMSUM,PASS1,NPASS= ',
     &  TEMKIL,TEMSUM,PASS1,NPASS 
        NPASS=NPASS-MAX(MINSTP,INT((TEMSUM-TEMKIL)/PASS1))
        IF(DEBUG)WRITE(JOSTND,*)' ADJUST= ',ADJUST,'  IS TO SMALL,',
     &  ' MIN STEP= ',MINSTP,' NEW NPASS= ',NPASS
        ISWTCH=1
        IF(NPASS .LE. 0)GO TO 110
        GO TO 105
      ELSEIF(ADJUST .GT. 1.2)THEN
        IF(ISWTCH .EQ. 1) GO TO 110
        NPASS=NPASS+MAX(MINSTP,INT((TEMKIL-TEMSUM)/PASS1))
        IF(DEBUG)WRITE(JOSTND,*)' ADJUST= ',ADJUST,'  IS TO BIG,',
     &  ' MIN STEP= ',MINSTP,' NEW NPASS= ',NPASS
        ISWTCH=2
        GO TO 105
      ENDIF
  110 CONTINUE
      SHORT=0.
      IF(DEBUG)WRITE(JOSTND,*)' TEMKIL= ',TEMKIL,'  TEMSUM= ',
     &TEMSUM,'  ADJUSTMENT= ',ADJUST   
      DO 150 I=1,ITRN
        TPALFT = PROB(I)-WK2(I)
        IF(TPALFT .LT. 0.00001)GO TO 150
        XKILL=TEMWK2(I)*ADJUST
        IF((PROB(I)-WK2(I)-XKILL) .LE. 0.00001) THEN
          TEMWK2(I)=PROB(I)-WK2(I)
          IF(DEBUG)WRITE(JOSTND,*)' SHORT,I,XKILL,PROB,WK2= ',
     &    SHORT,I,XKILL,PROB(I),WK2(I) 
          SHORT=SHORT+(XKILL-PROB(I)+WK2(I))
          IF(DEBUG)WRITE(JOSTND,*)' SHORT= ',SHORT
          PASS1=PASS1-EFFTR(I)
          GO TO 140
        ENDIF
        TEMWK2(I)=XKILL
  140 CONTINUE
      WK2(I)=WK2(I)+TEMWK2(I)
      SUMKIL=SUMKIL+TEMWK2(I)
  150 CONTINUE
      IF(DEBUG)WRITE(JOSTND,23)ITRN,(WK2(IG),IG=1,ITRN)
   23 FORMAT(' ADJUSTED MORTALITY VALUES, ITRN = ',I7,
     &(/10F10.5))
      IF(DEBUG)WRITE(JOSTND,*)' SHORT = ',SHORT
      IF(SHORT .GT. 0.)THEN
        NPASS=INT(SHORT/PASS1)+1
        IF(DEBUG)WRITE(JOSTND,*)' SHORT,PASS1, ADJUSTED PASSES NEEDED',
     &  '= ',SHORT,PASS1,NPASS
        GO TO 100
      ENDIF
C
      RETURN
      END
