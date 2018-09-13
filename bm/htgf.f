      SUBROUTINE HTGF
      IMPLICIT NONE
C----------
C BM $Id$
C----------
C  THIS SUBROUTINE COMPUTES THE PREDICTED PERIODIC HEIGHT
C  INCREMENT FOR EACH CYCLE AND LOADS IT INTO THE ARRAY HTG.
C  HEIGHT INCREMENT IS PREDICTED FROM SPECIES, HABITAT TYPE,
C  HEIGHT, DBH, AND PREDICTED DBH INCREMENT.  THIS ROUTINE
C  IS CALLED FROM **TREGRO** DURING REGULAR CYCLING.  ENTRY
C  **HTCONS** IS CALLED FROM **RCON** TO LOAD SITE DEPENDENT
C  CONSTANTS THAT NEED ONLY BE RESOLVED ONCE.
C  CALLS ***FINDAG
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
      INCLUDE 'HTCAL.F77'
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
COMMONS
C
C----------
C  VARIABLE DECLARATIONS:
C----------
C
      LOGICAL DEBUG
C
      INTEGER I,I1,I2,I3,IICR,ISPC,ITFN,IXAGE,J,K,KEYCR,L
C
      REAL AGMAX,AGP10,AZBIAS,BAL,BARK,BRATIO,BZBIAS,CLOSUR,CRA,CRB,CRC
      REAL D1,D2,DIA,FBY1,FBY2,FCTRKX,FCTRM,FCTRRB,FCTRXB,H,HGMDCR
      REAL HGMDRH,HGUESS,HHT,HTGMOD,HTI,HTMAX,HTMAX2,HTNEW,MISHGF,POTHTG
      REAL PSI,RELHT,RELSI,RHK,RHX,RHXS,SCALE,SHI,SI,SINDX,SITAGE,SITHT
      REAL SLO,TEMHTG,TEMPH,WTCR,WTRH,XHT,XI1,XI2,Y1,Y2,Z,ZADJ,ZBIAS
      REAL ZTEST
C
      REAL AASM(MAXSP),BASM(MAXSP),COF(9,5),COF1(9,3),COF6(9,5)
      REAL RHB(MAXSP),RHM(MAXSP),RHR(MAXSP),RHYXS(MAXSP)
C
C----------
C  DATA STATEMENTS
C
C  SPECIES ORDER:
C   1=WP,  2=WL,  3=DF,  4=GF,  5=MH,  6=WJ,  7=LP,  8=ES,
C   9=AF, 10=PP, 11=WB, 12=LM, 13=PY, 14=YC, 15=AS, 16=CW,
C  17=OS, 18=OH
C
C  SPECIES EXPANSION:
C  WJ USES SO JU (ORIGINALLY FROM UT VARIANT; REALLY PP FROM CR VARIANT)
C  WB USES SO WB (ORIGINALLY FROM TT VARIANT)
C  LM USES UT LM
C  PY USES SO PY (ORIGINALLY FROM WC VARIANT)
C  YC USES WC YC
C  AS USES SO AS (ORIGINALLY FROM UT VARIANT)
C  CW USES SO CW (ORIGINALLY FROM WC VARIANT)
C  OS USES BM PP BARK COEFFICIENT
C  OH USES SO OH (ORIGINALLY FROM WC VARIANT)
C----------
      DATA AASM/    1.5,    2.0,     0.4,   2.1,    0.0,
     &               0.,    1.5,     1.5,   1.5,    1.3,
     &               0.,     0.,      0.,    0.,     0.,
     &               0.,    1.3,      0./
C
      DATA BASM/  0.003, 0.0026, 0.0080,    0.0,    0.0,
     &               0.,    0.0,    0.0,    0.0,  0.002,
     &               0.,     0.,     0.,     0.,     0.,
     &               0.,  0.002,     0./
C---------
C  COEFFICIENTS--CROWN RATIO (CR) BASED HT. GRTH. MODIFIER
C---------
      DATA CRA /100.0/, CRB /3.0/, CRC /-5.0/
C---------
C  COEFFICIENTS--RELATIVE HEIGHT (RH) BASED HT. GRTH. MODIFIER
C---------
      DATA RHK /1.0/, RHXS /0.0/
C-------
C  COEFFS BASED ON SPECIES SHADE TOLERANCE AS FOLLOWS:
C                                   RHR  RHYXS    RHM    RHB
C        VERY TOLERANT             20.0   0.20    1.1  -1.10
C        TOLERANT                  16.0   0.15    1.1  -1.20
C        INTERMEDIATE              15.0   0.10    1.1  -1.45
C        INTOLERANT                13.0   0.05    1.1  -1.60
C        VERY INTOLERANT           12.0   0.01    1.1  -1.60
C  IN THE BM VARIANT THE SHADE TOLLERANCE WAS RESOLVED TO THE RANGE
C  1 THROUGH 11, WITH 1 REPRESENTING THE MOST TOLERANT AND 11 THE
C  LEAST SHADE TOLERANT AS FOLLOWS
C  SEQ. NO.   CHAR. CODE    SHADE TOLERANCE     INDEX
C      1      WP            INTM                 7
C      2      WL            VINT                11
C      3      DF            INTM                 6
C      4      WF            TOLN                 3
C      5      MH            VTOL                 1
C      6
C      7      LP            VINT                10
C      8      ES            TOLN                 5
C      9      RF            TOLN                 4
C      10     PP            INTL                 9
C      17     OS (USE PP)   INTL                 9
C----------
      DATA RHR    / 15.0,  12.0,  15.0,  20.0,  20.0,
     &               0.0,  12.0,  16.0,  16.0,  13.0,
     &               0.0,   0.0,  20.0,  16.0,   0.0,
     &              12.0,  13.0,  15.0/
C
      DATA RHYXS  / 0.10,  0.01,  0.10,  0.20,  0.20,
     &               0.0,  0.01,  0.15,  0.15,  0.05,
     &               0.0,   0.0,  0.20,  0.15,   0.0,
     &              0.01,  0.05,  0.10/
C
      DATA RHM    / 1.10,  1.10,  1.10,  1.10,  1.10,
     &               0.0,  1.10,  1.10,  1.10,  1.10,
     &               0.0,   0.0,  1.10,  1.10,   0.0,
     &              1.10,  1.10,  1.10/
C
      DATA RHB    /-1.45, -1.60, -1.45, -1.10, -1.10,
     &               0.0, -1.60, -1.20, -1.20, -1.60,
     &               0.0,   0.0, -1.10, -1.20,   0.0,
     &             -1.60, -1.60, -1.45/
C
      DATA AZBIAS /0.0/
C
      DATA BZBIAS /0.0/
C----------
C  COF1 IS FROM TT/HTGF FOR WHITEBARK PINE AND ALSO
C          FROM UT/HTGF FOR LIMBER PINE
C----------
       DATA COF1/
     +37.0,85.0,1.77836,-0.51147,1.88795,1.20654,0.57697,
     +3.57635,0.90283,
     +45.0,100.0,1.66674,0.25626,1.45477,1.11251,0.67375,
     +2.17942,0.88103,
     +45.0,90.0,1.64770,0.30546,1.35015,0.94823,0.70453,
     +2.46480,1.00316/
C----------
C  COF6 IS FROM UT/HTGF FOR QUAKING ASPEN
C----------
       DATA COF6/
     +30.0,85.0,2.00995,0.03288,1.81059,1.28612,0.72051,
     +3.00551,1.01433,
     +30.0,85.0,2.00995,0.03288,1.81059,1.28612,0.72051,
     +3.00551,1.01433,
     +35.0,85.0,1.80388,-0.07682,1.70032,1.29148,0.72343,
     +2.91519,0.95244,
     +18*0.0/
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'HTGF',4,ICYC)
      IF (DEBUG) WRITE(JOSTND,3) ICYC
    3 FORMAT(' ENTERING SUBROUTINE HTGF  CYCLE =',I5)
      IF(DEBUG)WRITE(JOSTND,*) 'IN HTGF AT BEGINNING,HTCON=',
     *HTCON,'RMAI=',RMAI,'ELEV=',ELEV
C
      SCALE=FINT/YR
C----------
C  GET THE HEIGHT GROWTH MULTIPLIERS.
C----------
      CALL MULTS (2,IY(ICYC),XHMULT)
      IF(DEBUG)WRITE(JOSTND,*)'HTGF- IY(ICYC),XHMULT= ',
     & IY(ICYC), XHMULT
C----------
C   BEGIN SPECIES LOOP.
C----------
      DO 40 ISPC=1,MAXSP
C----------
C  GET THE APPROPRIATE SITE INDEX RANGE VALUES FOR THIS SPECIES.
C----------
        SLO = 0.
        SHI = 999.
        CALL SITERANGE (3,ISPC,SLO,SHI)
C
      I1 = ISCT(ISPC,1)
      IF (I1 .EQ. 0) GO TO 40
      I2 = ISCT(ISPC,2)
      SINDX = SITEAR(ISPC)
      XHT=XHMULT(ISPC)
C-----------
C   BEGIN TREE LOOP WITHIN SPECIES LOOP
C-----------
      DO 30 I3 = I1,I2
      I=IND1(I3)
      HTG(I)=0.
      BAL=((100.0-PCT(I))/100.)*BA
      H=HT(I)
      IF (PROB(I).LE.0.) GO TO 161
      HGUESS=0.0
      AGP10=0.0
C
      SITAGE = 0.0
      SITHT = 0.0
      AGMAX = 0.0
      HTMAX = 0.0
      HTMAX2 = 0.0
      D1 = DBH(I)
      D2 = 0.0
      CALL FINDAG(I,ISPC,D1,D2,H,SITAGE,SITHT,AGMAX,HTMAX,HTMAX2,DEBUG)
C
      IF(H .GE. HTMAX) THEN
        SI=SITEAR(ISPC)
        IF(SI .GT. SHI)SI=SHI
        IF(SI .LE. SLO)SI=SLO + 0.5
        RELSI = (SI -SLO)/(SHI - SLO)
        HTG(I)=AASM(ISPC) + BASM(ISPC) * RELSI
        IF(HTG(I).LT.0.1)HTG(I)=0.1
        HTG(I)=HTG(I)*XHT*SCALE*EXP(HTCON(ISPC))
        GO TO 161
      ENDIF
C----------
C  NORMAL HEIGHT INCREMENT CALCULATON BASED ON INCOMMING TREE AGE
C  FIRST CHECK FOR MAX, ASMYPTOTIC HEIGHT
C----------
      IF (SITAGE .GT. AGMAX) THEN
        POTHTG= 0.1
C----------
C THE FOLLOWING 'IF' BLOCK IS AN RJ FIX.  8-22-88
C----------
        IF(ISPC .EQ. 10 .OR. ISPC .EQ. 17) THEN
          POTHTG = -1.31 + 0.05 * SINDX
          IF(POTHTG .LT. 0.1) POTHTG = 0.1
        ENDIF
        GO TO 1320
      ELSE
        AGP10= SITAGE + 10.
      ENDIF
C----------
C  WJ FROM UT USES HEIGHT INCREMENT FROM **REGENT**
C----------
      IF(ISPC.EQ.6)GO TO 999
C----------
C  CALL HTCALC FOR NORMAL CYCLING
C----------
C
      SELECT CASE (ISPC)
C
      CASE(11,12,15)
C----------
C  WHITEBARK PINE, LIMBER PINE, AND QUAKING ASPEN - JOHNSON'S SBB METHOD
C----------
        IF(ISPC.EQ.11 .OR. ISPC.EQ.12)THEN
          DO J=1,3
          DO K=1,9
          COF(K,J)=COF1(K,J)
          ENDDO
          ENDDO
        ELSE
          DO J=1,5
          DO K=1,9
          COF(K,J)=COF6(K,J)
          ENDDO
          ENDDO
        ENDIF
        XI2=4.5
        XI1=0.1
C----------
C  TRAP TO AVOID LOG(0) ERRORS WITH XI1 AND XI2; HTG WILL COME FROM
C  REGENT FOR THESE SMALL OF TREES ANYWAY.  GED 05/07/09
C
        IF(DBH(I) .LE. 0.1 .OR. HT(I).LE. 4.5)GO TO 180
C----------
        HTG(I)=0.
        HTI=HT(I)
        BARK=BRATIO(ISPC,DBH(I),HTI)
        IF(DEBUG)WRITE(JOSTND,*)' HTI, BARK= ',HTI, BARK
C
C    CHANGE THE CROWN RATIO TO AN INTEGER BETWEEN 0 AND 10
C
        IICR= INT(REAL(ICR(I))/10.0 + 0.5)
C
C    PLACE THE CROWN RATIO INTO ONE OF THREE GROUPS
C
        IF(IICR .GT. 9) IICR=9
        GO TO(101,101,102,102,102,102,102,103,103),IICR
  101   KEYCR=1
        GO TO 110
  102   KEYCR=2
        GO TO 110
  103   KEYCR=3
  110   CONTINUE
C
C  ROW IDENT FOR SBB COEF LOOKUP
C
        K= KEYCR
C
C  CHECK IF HEIGHT OR DBH EXCEED PARAMETERS
C
        IF(DEBUG)
     &    WRITE(JOSTND,9101)(COF(L,K),L=1,9)
 9101   FORMAT(' COFS= ',9F10.4)


        IF (HTI.LE. 4.5) GOTO 180
        IF((XI1 + COF(1,K)) .LE. DBH(I)) GO TO 180
        IF((XI2 + COF(2,K)) .LE. HTI) GO TO 180
C
        IF(DEBUG)WRITE(JOSTND,*)' XI1, XI2, DBH, HTI,COF(1,K),',
     &  'COF(2,K)= ',XI1, XI2, DBH(I), HTI,COF(1,K),COF(2,K)
C
        GO TO 190
  180   CONTINUE
C
C    THE SBB IS UNDEFINED IF CERTAIN INPUT VALUES EXCEED PARAMETERS IN
C    THE FITTED DISTRIBUTION.  IN INPUT VALUES ARE EXCESSIVE THE HEIGHT
C    GROWTH IS TAKEN TO BE 0.1 FOOT.
C
        HTG(I) = 0.1
        GO TO 25
  190   CONTINUE
C
C CALCULATE ALPHA FOR THE TREE USING SCHREUDER + HAFLEY
C
        Y1=(DBH(I) - XI1)/COF(1,K)
        Y2=(HT(I) - XI2)/COF(2,K)
        IF(DEBUG)WRITE(JOSTND,*)' K,COF,DBH,XI1= ',K,COF(1,K),DBH(I),XI1
        IF(DEBUG)WRITE(JOSTND,*)' Y1,Y2,HT,XI2= ',Y1,Y2,HT(I),XI2
C
        FBY1=ALOG(Y1/(1.0 - Y1))
        FBY2= ALOG(Y2/(1.0 - Y2))
        Z=( COF(4,K) + COF(6,K)*FBY2 - COF(7,K)*( COF(3,K) +
     +   COF(5,K)*FBY1))*(1.0 - COF(7,K)**2)**(-0.5)
        IF(DEBUG)WRITE(JOSTND,*)' K,COF(1,K)= ',K,COF(1,K)
        IF(DEBUG)WRITE(JOSTND,*)' K,COF(2,K)= ',K,COF(2,K)
C
C THE HT DIA MODEL NEEDS MODIFICATION TO CORRECT KNOWN BIAS
C THE COEFFS FOR AZBIAS AND BZBIAS ARE ZERO FOR THESE SPECIES
C
        ZBIAS=AZBIAS+BZBIAS*ELEV
        IF(ISPC.EQ.15)ZBIAS=AZBIAS+BZBIAS*(ELEV-20.)
        IF(ELEV .LT. 55. .OR. ELEV .GT. 80.0)ZBIAS=0.0
        ZTEST=Z-ZBIAS
        IF(ZTEST .GE. 2.0 .AND. ZBIAS .LT. 0.0)ZBIAS=0.0
        Z=Z-ZBIAS
        IF(ISPC.EQ.12 .OR. ISPC.EQ.15)THEN
          ZADJ = .1 - .10273*Z + .00273*Z*Z
          IF(ZADJ .LT. 0.0)ZADJ=0.0
          Z=Z+ZADJ
        ENDIF
        IF(DEBUG)WRITE(JOSTND,*)' I,Z,K,Y1,Y2,DBH(I),FBY1,FBY2= '
        IF(DEBUG)WRITE(JOSTND,*)I,Z,K,Y1,Y2,DBH(I),FBY1,FBY2
C
C YOUNG SMALL LODGEPOLE HTG ACCELLERATOR BASED ON TARGHEE HTG
C TEMP BYPASS
C
        IF((ICYC .GT. 1) .OR. (IAGE .LE. 0))GO TO 184
        IXAGE=IAGE + IY(ICYC) -IY(1)
C
        IF(DEBUG)
     &  WRITE(JOSTND,*)' I, ISPC, IXAGE= ',I, ISPC, IXAGE
C
        IF(IXAGE .LT. 40. .AND. IXAGE .GT. 10. .AND. DBH(I)
     &     .LT. 9.0)THEN
          IF(Z .GT. 2.0) GO TO 184
          ZADJ=.3564*DG(I)*FINT/YR
          CLOSUR=PCT(I)/100.0
          IF(RELDEN .LT. 100.0)CLOSUR=1.0
          IF(DEBUG)WRITE(JOSTND,9650)ZBIAS,ELEV,IXAGE,ZADJ,FINT,YR,
     &     DG(I),CLOSUR
 9650     FORMAT(' ZBIAS',F8.0,'ELEV',F6.1,'AGE',F5.0,'ZADJ',
     &    F10.4,'FINT',F6.0,'YR',F6.0,'DG',F10.3,'CLOSUR',F10.1)
          ZADJ=ZADJ*CLOSUR
C
C ADJUSTMENT IS HIGHER FOR LONG CROWNED TREES
C
          IF(IICR .EQ. 9 .OR. IICR .EQ. 8)ZADJ=ZADJ*1.1
          Z=Z + ZADJ
          IF(Z .GT. 2.0)Z=2.0
        END IF
  184   CONTINUE
C
C CALCULATE DIAMETER AFTER 10 YEARS
C
        DIA= DBH(I) + DG(I)/BARK
        IF((XI1 + COF(1,K)) .GT. DIA) GO TO 185
        HTG(I)=0.1
        GO TO 25
  185   CONTINUE
C
C  CALCULATE HEIGHT AFTER 10 YEARS
C
        PSI= COF(8,K)*((DIA-XI1)/(XI1 + COF(1,K) - DIA))**COF(9,K)
     +     * (EXP(Z*((1.0 - COF(7,K)**2  ))**0.5/COF(6,K)))
C
        HHT= ((PSI/(1.0 + PSI))* COF(2,K)) + XI2
C
        IF(.NOT. DEBUG)GO TO 191
        WRITE(JOSTND,9631)DBH(I),DIA,HTI,DG(I),Z ,HHT
 9631   FORMAT(1X,'IN HTCALC DIA=',F7.3,'DIA+10=',F7.3,'HTI',F7.1,
     &  'DIA GR=',F8.3,'Z=',E15.8,'NEW H=',F8.1)
  191   CONTINUE
C
C  CALCULATE HEIGHT GROWTH
C   NEGATIVE HEIGHT GROWTH IS NOT ALLOWED
C
        IF(HHT .LT. HTI) HHT=HTI
        HTG(I)= HHT - HTI
        IF(HTG(I).LT.0.1)HTG(I)=0.1
C
        IF(DEBUG)WRITE(JOSTND,*)' I,HHT,HTI,HTG(I)= ',
     &   I,HHT,HTI,HTG(I)
   25   CONTINUE
C
      CASE DEFAULT
C----------
C  CALL HTCALC HERE TO CALCULATE POTENTIAL HT GROWTH FOR ALL
C  SPECIES EXCEPT 6, 11, 12, AND 15
C----------
      IF(DEBUG)WRITE(JOSTND,*)' ISPC,I,HT,AGP10= ',ISPC,I,HT(I),AGP10
C
      CALL HTCALC (SINDX,ISPC,AGP10,HGUESS,JOSTND,DEBUG)
      POTHTG=HGUESS - SITHT
C----------
C  HEIGHT GROWTH MUST BE POSITIVE
C----------
      IF(POTHTG .LT. 0.1)POTHTG= 0.1
C
      END SELECT
C----------
C  WB(11), LM(12) AND AS(15) DO NOT GET MODIFIED HERE
C----------
      IF(ISPC.EQ.11 .OR. ISPC.EQ.12 .OR. ISPC.EQ.15) GO TO 999
C
C----------
C  HEIGHT GROWTH MODIFIERS
C----------
 1320 CONTINUE
      IF(DEBUG)WRITE(JOSTND,*) ' AT 1320 CONTINUE FOR TREE',I,' HT= ',
     &HT(I),' AVH= ',AVH 
      RELHT = 0.
      IF(AVH .GT. 0.) RELHT=HT(I)/AVH
      IF(RELHT .GT. 1.5)RELHT=1.5
C-----------
C     REVISED HEIGHT GROWTH MODIFIER APPROACH.
C-----------
C     CROWN RATIO CONTRIBUTION.  DATA AND READINGS INDICATE HEIGHT
C     GROWTH PEAKS IN MID-RANGE OF CR, DECREASES SOMEWHAT FOR LARGE
C     CROWN RATIOS DUE TO PHOTOSYNTHETIC ENERGY PUT INTO CROWN SUPPORT
C     RATHER THAN HT. GROWTH.  CROWN RATIO FOR THIS COMPUTATION NEEDS
C     TO BE IN (0-1) RANGE; DIVIDE BY 100.  FUNCTION IS HOERL'S
C     SPECIAL FUNCTION (REF. P.23, CUTHBERT&WOOD, FITTING EQNS. TO DATA
C     WILEY, 1971).  FUNCTION OUTPUT CONSTRAINED TO BE 1.0 OR LESS.
C-----------
      HGMDCR = (CRA * (ICR(I)/100.)**CRB) * EXP(CRC*(ICR(I)/100.))
      IF (HGMDCR .GT. 1.) HGMDCR = 1.
C-----------
C     RELATIVE HEIGHT CONTRIBUTION.  DATA AND READINGS INDICATE HEIGHT
C     GROWTH IS ENHANCED BY STRONG TOP LIGHT AND HINDERED BY HIGH
C     SHADE EVEN IF SOME LIGHT FILTERS THROUGH.  ALSO RESPONSE IS
C     GREATER FOR GIVEN LIGHT AS SHADE TOLERANCE INCREASES.  FUNCTION
C     IS GENERALIZED CHAPMAN-RICHARDS (REF. P.2 DONNELLY ET AL. 1992.
C     THINNING EVEN-AGED FOREST STANDS...OPTIMAL CONTROL ANALYSES.
C     USDA FOR. SERV. RES. PAPER RM-307).
C     PARTS OF THE GENERALIZED CHAPMAN-RICHARDS FUNCTION USED TO
C     COMPUTE HGMDRH BELOW ARE SEGMENTED INTO FACTORS
C     FOR PROGRAMMING CONVENIENCE.
C-----------
      RHX = RELHT
      FCTRKX = ( (RHK/RHYXS(ISPC))**(RHM(ISPC)-1.) ) - 1.
      FCTRRB = -1.0*( RHR(ISPC)/(1.0-RHB(ISPC)) )
      FCTRXB = RHX**(1.0-RHB(ISPC)) - RHXS**(1.0-RHB(ISPC))
      FCTRM  = -1.0/(RHM(ISPC)-1.)
      IF (DEBUG)
     &WRITE(JOSTND,*) ' HTGF-HGMDRH FACTORS = ',
     &ISPC, RHX, FCTRKX, FCTRRB, FCTRXB, FCTRM
      HGMDRH = RHK * ( 1.0 + FCTRKX*EXP(FCTRRB*FCTRXB) ) ** FCTRM
C-----------
C     APPLY WEIGHTED MODIFIER VALUES.
C-----------
      WTCR = .25
      WTRH = 1.0 - WTCR
      HTGMOD = WTCR*HGMDCR + WTRH*HGMDRH
C----------
C    MULTIPLIED BY SCALE TO CHANGE FROM A YR. PERIOD TO FINT AND
C    MULTIPLIED BY XHT TO APPLY USER SUPPLIED GROWTH MULTIPLIERS.
C----------
C
      IF(DEBUG) THEN
        WRITE(JOSTND,*)' IN HTGF, I= ',I,' ISPC= ',ISPC,'HTGMOD= ',
     &  HTGMOD,' ICR= ',ICR(I),' HGMDCR= ',HGMDCR
        WRITE(JOSTND,*)' HT(I)= ',HT(I),' AVH= ',AVH,' RELHT= ',RELHT,
     & ' HGMDRH= ',HGMDRH
      ENDIF
C
      IF (HTGMOD .GE. 2.) HTGMOD= 2.
      IF (HTGMOD .LE. 0.1) HTGMOD= 0.1
C
      HTG(I) = POTHTG * HTGMOD
C
      IF(DEBUG)WRITE(JOSTND,901)ICR(I),PCT(I),BA,DG(I),HT(I),POTHTG,
     &  BAL,AVH,HTG(I),PCCF(ITRE(I)),ABIRTH(I),HGUESS,HTGMOD
  901 FORMAT(' HTGF',I5,13F9.2)
C
  999 CONTINUE
C-----------
C   HEIGHT GROWTH EQUATION, EVALUATED FOR EACH TREE EACH CYCLE
C   MULTIPLIED BY SCALE TO CHANGE FROM A YR. PERIOD TO FINT AND
C   MULTIPLIED BY XHT TO APPLY USER SUPPLIED GROWTH MULTIPLIERS.
C
C   CHECK FOR HT GT MAX HT FOR THE SITE AND SPECIES
C----------
      TEMPH=H + HTG(I)
      IF(TEMPH .GT. HTMAX)THEN
        HTG(I)=HTMAX - H
      ENDIF
      IF(HTG(I).LT.0.1)HTG(I)=0.1
      HTG(I)=SCALE*XHT*HTG(I)*EXP(HTCON(ISPC))
C
      IF(DEBUG)THEN
      HTNEW=HT(I)+HTG(I)
      WRITE (JOSTND,9000) HTG(I),HTCON(ISPC),H2COF,
     & WK1(I),HTNEW,I,ISPC
 9000 FORMAT(' 9000 HTGF, HTG=',F8.4,' HTCON=',F8.4,
     & ' H2COF=',F12.8,' WK1=',F8.4/,
     & ' HTNEW=',F8.4,' I=',I4,' ISPC=',I2)
      ENDIF
C
  161 CONTINUE
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
      IF(.NOT.LTRIP) GO TO 30
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
C----------
C   END OF TREE LOOP
C----------
   30 CONTINUE
C----------
C   END OF SPECIES LOOP
C----------
   40 CONTINUE
      IF(DEBUG)WRITE(JOSTND,60)ICYC
   60 FORMAT(' LEAVING SUBROUTINE HTGF   CYCLE =',I5)
      RETURN
C
      ENTRY HTCONS
C----------
C  ENTRY POINT FOR LOADING HEIGHT INCREMENT MODEL COEFFICIENTS THAT
C  ARE SITE DEPENDENT AND REQUIRE ONE-TIME RESOLUTION.  HGHC
C  CONTAINS HABITAT TYPE INTERCEPTS, HGLDD CONTAINS HABITAT
C  DEPENDENT COEFFICIENTS FOR THE DIAMETER INCREMENT TERM, HGH2
C  CONTAINS HABITAT DEPENDENT COEFFICIENTS FOR THE HEIGHT-SQUARED
C  TERM, AND HGHC CONTAINS SPECIES DEPENDENT INTERCEPTS.  HABITAT
C  TYPE IS INDEXED BY ITYPE (SEE /PLOT/ COMMON AREA).
C----------
C  LOAD OVERALL INTERCEPT FOR EACH SPECIES.
C----------
C  LOAD OVERALL INTERCEPT FOR EACH SPECIES.
C----------
      DO 50 ISPC=1,MAXSP
      HTCON(ISPC)=0.0
      IF(LHCOR2 .AND. HCOR2(ISPC).GT.0.0) HTCON(ISPC)=
     &    HTCON(ISPC)+ALOG(HCOR2(ISPC))
   50 CONTINUE
C
      RETURN
      END
