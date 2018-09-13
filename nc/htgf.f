      SUBROUTINE HTGF
      IMPLICIT NONE
C----------
C NC $Id$
C----------
C  THIS SUBROUTINE COMPUTES THE PREDICTED PERIODIC HEIGHT
C  INCREMENT FOR EACH CYCLE AND LOADS IT INTO THE ARRAY HTG.
C  HEIGHT INCREMENT IS PREDICTED FROM SPECIES, HABITAT TYPE,
C  HEIGHT, DBH, AND PREDICTED DBH INCREMENT.  THIS ROUTINE
C  IS CALLED FROM **TREGRO** DURING REGULAR CYCLING.  ENTRY
C  **HTCONS** IS CALLED FROM **RCON** TO LOAD SITE DEPENDENT
C  CONSTANTS THAT NEED ONLY BE RESOLVED ONCE.
C----------
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
      INCLUDE 'OUTCOM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'MULTCM.F77'
C
C
      INCLUDE 'HTCAL.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
COMMONS
C----------
      LOGICAL DEBUG
      INTEGER I,ISPC,I1,I2,I3,ITFN
      REAL AGP05,HGUESS,SCALE,P1,P2,P3,P4,SINDX,XHT,H,POTHTG
      REAL XMOD,RELHT,CR,TEMHTG
      REAL HD1(MAXSP),HD2(MAXSP),HD3(MAXSP),HD4(MAXSP)
      REAL D1,D2,SITAGE,SITHT,AGMAX,HTMAX,HTMAX2
      REAL MISHGF
C----------
C  DATA STATEMENTS
C----------
      DATA HD1/4*0.0,4.4666 ,0.0, 4.80758, 4.9684, 0.0,0.0,4.9684/
      DATA HD2/4*0.0,-0.00179,0.0,-0.00224,-0.004057,2*0.0,-0.004057/
      DATA HD3/4*0.0,0.002048,0.0,-0.000513,0.000924,2*0.0,0.000924/
      DATA HD4/4*0.0,-7.9428,0.0,-7.729644,-10.45158,2*0.0,-10.45158/
C----------
C   MODEL COEFFICIENTS AND CONSTANTS:
C
C    IND2 -- ARRAY OF POINTERS TO SMALL TREES.
C
C   SCALE -- TIME FACTOR DERIVED BY DIVIDING FIXED POINT CYCLE
C            LENGTH BY GROWTH PERIOD LENGTH FOR DATA FROM
C            WHICH MODELS WERE DEVELOPED.
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'HTGF',4,ICYC)
      IF(DEBUG) WRITE(JOSTND,3)ICYC
    3 FORMAT(' ENTERING SUBROUTINE HTGF  CYCLE =',I5)
      IF(DEBUG)WRITE(JOSTND,*) 'IN HTGF AT BEGINNING,HTCON=',
     *HTCON,'RMAI=',RMAI,'ELEV=',ELEV
C
      AGP05=0.0
      SCALE=FINT/YR
C----------
C  GET THE HEIGHT GROWTH MULTIPLIERS.
C----------
      CALL MULTS (2,IY(ICYC),XHMULT)
C----------
C   BEGIN SPECIES LOOP. LOAD BETA COEFFICIENTS.
C----------
      DO 4000 ISPC=1,MAXSP
C----------
C FOLLOWING ARE COEFS FOR THE HT DIA BASED HTG FCN
C----------
      P1 = HD1(ISPC)
      P2 = HD2(ISPC)
      P3 = HD3(ISPC)
      P4 = HD4(ISPC)
      SINDX = SITEAR(ISPC)
      XHT=1.0
      XHT=XHMULT(ISPC)
C
      IF(DEBUG)WRITE(JOSTND,*)'HTDIACOF',ISPC,P1,P2,P3,P4
C----------
C END OF BETS COEFS
C----------
      I1 = ISCT(ISPC,1)
      IF (I1 .EQ. 0) GO TO 4000
      I2 = ISCT(ISPC,2)
C-----------
C   BEGIN TREE LOOP WITHIN SPECIES LOOP
C-----------
      DO 3000 I3=I1,I2
      I=IND1(I3)
      HTG(I)=0.
      IF(PROB(I) .LE. 0.0)GO TO 2600
      H=HT(I)
C
      HGUESS=0.0
      SITAGE = 0.0
      SITHT = 0.0
      AGMAX = 0.0
      HTMAX = 0.0
      HTMAX2 = 0.0
      D1 = DBH(I)
      D2 = 0.0
      IF(DEBUG)WRITE(JOSTND,*)' IN HTGF, CALLING FINDAG I= ',I
      CALL FINDAG(I,ISPC,D1,D2,H,SITAGE,SITHT,AGMAX,HTMAX,HTMAX2,DEBUG)
C
C----------
C   CALCULATE THE HTG VIA SITE AND MODIFER TECHNIQUE
C----------
      IF(H .GE. HTMAX)THEN
        HTG(I)=0.1
        HTG(I)=SCALE*XHT*HTG(I)*EXP(HTCON(ISPC))
        GO TO 2600
      END IF
C----------
C  NORMAL HEIGHT INCREMENT CALCULATON BASED ON TREE AGE
C  FIRST CHECK FOR MAXIMUM TREE AGE
C----------
      IF (SITAGE .GE. AGMAX) THEN
        POTHTG= 0.10
        GO TO 140
      ELSE
        AGP05= SITAGE + 5.0
      ENDIF
C----------
C  CALL HTCALC FOR NORMAL CYCLING
C----------
      CALL HTCALC(SINDX,ISPC,AGP05,HGUESS,JOSTND,DEBUG)
      POTHTG = HGUESS - SITHT
      IF(DEBUG)WRITE(JOSTND,*)' AGP05, HGUESS, H= ',AGP05,HGUESS,H
C----------
C ASSIGN A POTENTIAL HTG FOR THE ASYMPTOTIC AGE
C----------
  140 CONTINUE
      XMOD=1.0
      IF(PCCF(ITRE(I)) .LT. 50.0)GO TO 170
      RELHT = H/AVH
C----------
C LESSEN THE IMPACT OF RELHT FOR MODERATELY STOCKED STANDS
C----------
      IF(PCCF(ITRE(I)) .LT. 100.0) RELHT = (RELHT + 1.0) / 2.0
      IF(RELHT .GT. 1.0)RELHT = 1.0
      CR = ICR(I)/10.
C----------
C FOLLOWING MODIFIER IS BASED ON DF DATA
C----------
      XMOD = -0.02647 + 0.71338*RELHT*RELHT + 0.06851*CR
  170 CONTINUE
      HTG(I) = POTHTG * XMOD
      IF(HTG(I) .LE. 0.1)HTG(I)=0.01
C-----------
C   HEIGHT GROWTH EQUATION, EVALUATED FOR EACH TREE EACH CYCLE
C   MULTIPLIED BY SCALE TO CHANGE FROM A YR. PERIOD TO FINT AND
C   MULTIPLIED BY XHT TO APPLY USER SUPPLIED GROWTH MULTIPLIERS.
C----------
      HTG(I)=SCALE*XHT*HTG(I)*EXP(HTCON(ISPC))
      IF(DEBUG)WRITE(JOSTND,*)' I,ISPC,XHT,SCALE,HTG,HTCON= ',
     & I,ISPC,XHT,SCALE,HTG(I),HTCON(ISPC)
 2600 CONTINUE
C----------
C    APPLY DWARF MISTLETOE HEIGHT GROWTH IMPACT HERE,
C    INSTEAD OF AT EACH FUNCTION IF SPECIAL CASES EXIST.
C----------
      HTG(I)=HTG(I)*MISHGF(I,ISPC)
      TEMHTG=HTG(I)
C----------
C CHECK FOR SIZE CAP COMPLIANCE.
C----------
      IF((HT(I)+HTG(I)).GT.SIZCAP(ISPC,4))THEN
        HTG(I)=SIZCAP(ISPC,4)-HT(I)
        IF(HTG(I) .LT. 0.1) HTG(I)=0.1
      ENDIF
C
      IF(.NOT.LTRIP) GO TO 3000
      ITFN=ITRN+2*I-1
      HTG(ITFN)=TEMHTG
C----------
C CHECK FOR SIZE CAP COMPLIANCE.
C----------
      IF((HT(ITFN)+HTG(ITFN)).GT.SIZCAP(ISPC,4))THEN
        HTG(ITFN)=SIZCAP(ISPC,4)-HT(ITFN)
        IF(HTG(ITFN) .LT. 0.1) HTG(ITFN)=0.1
      ENDIF
C
      HTG(ITFN+1)=TEMHTG
C----------
C CHECK FOR SIZE CAP COMPLIANCE.
C----------
      IF((HT(ITFN+1)+HTG(ITFN+1)).GT.SIZCAP(ISPC,4))THEN
        HTG(ITFN+1)=SIZCAP(ISPC,4)-HT(ITFN+1)
        IF(HTG(ITFN+1) .LT. 0.1) HTG(ITFN+1)=0.1
      ENDIF
C
      IF(DEBUG) WRITE(JOSTND,9001) HTG(ITFN),HTG(ITFN+1)
 9001 FORMAT( ' UPPER HTG =',F8.4,' LOWER HTG =',F8.4)
C
 3000 CONTINUE
C----------
C   END OF SPECIES LOOP
C----------
 4000 CONTINUE
      IF(DEBUG)WRITE(JOSTND,60)ICYC
   60 FORMAT(' LEAVING SUBROUTINE HTGF   CYCLE =',I5)
      RETURN
C
      ENTRY HTCONS
C----------
C  ENTRY POINT FOR LOADING HEIGHT INCREMENT MODEL COEFFICIENTS THAT
C  ARE SITE DEPENDENT AND REQUIRE ONE-TIME RESOLUTION.
C----------
      DO 50 ISPC=1,MAXSP
      HTCON(ISPC)=0.0
      IF(LHCOR2 .AND. HCOR2(ISPC).GT.0.0) HTCON(ISPC)=
     &    HTCON(ISPC)+ALOG(HCOR2(ISPC))
   50 CONTINUE
C
      RETURN
      END
