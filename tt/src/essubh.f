      SUBROUTINE ESSUBH (I,HHT,EMSQR,DILATE,DELAY,ELEV,ISER,GENTIM,
     &                   TRAGE)
      IMPLICIT NONE
C----------
C TT $Id: essubh.f 0000 2018-02-14 00:00:00Z gedixon $
C----------
C
C     ASSIGNS HEIGHTS TO SUBSEQUENT AND PLANTED TREE RECORDS
C     CREATED BY THE ESTABLISHMENT MODEL.
C
C
C     COMING INTO ESSUBH, TRAGE IS THE AGE OF THE TREE AS SPECIFIED ON 
C     THE PLANT OR NATURAL KEYWORD.  LEAVING ESSUBH, TRAGE IS THE NUMBER 
C     BETWEEN PLANTING (OR NATURAL REGENERATION) AND THE END OF THE 
C     CYCLE.  AGE IS TREE AGE UP TO THE TIME REGENT WILL BEGIN GROWING 
C     THE TREE.
C     CALLED FORM **ESTAB
C----------
C  COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ESPARM.F77'
C
C
      INCLUDE 'ESCOMN.F77'
C
C  COMMONS
C----------
C  DECLARATIONS
C----------
      INTEGER I,ISER,N,IAGE,ITIME
      REAL    HHT,DELAY,DILATE,ELEV,EMSQR,GENTIM,TRAGE,AGE
      REAL    UPRE(4),AGELN,BNORM,PN
      INTEGER IDANUW
C----------
C SPECIES ORDER FOR TETONS VARIANT:
C
C  1=WB,  2=LM,  3=DF,  4=PM,  5=BS,  6=AS,  7=LP,  8=ES,  9=AF, 10=PP,
C 11=UJ, 12=RM, 13=BI, 14=MM, 15=NC, 16=MC, 17=OS, 18=OH
C
C VARIANT EXPANSION:
C BS USES ES EQUATIONS FROM TT
C PM USES PI (COMMON PINYON) EQUATIONS FROM UT
C PP USES PP EQUATIONS FROM CI
C UJ AND RM USE WJ (WESTERN JUNIPER) EQUATIONS FROM UT
C BI USES BM (BIGLEAF MAPLE) EQUATIONS FROM SO
C MM USES MM EQUATIONS FROM IE
C NC AND OH USE NC (NARROWLEAF COTTONWOOD) EQUATIONS FROM CR
C MC USES MC (CURL-LEAF MTN-MAHOGANY) EQUATIONS FROM SO
C OS USES OT (OTHER SP.) EQUATIONS FROM TT
C----------
C     FOR PONDEROSA PINE FROM THE CI VARIANT,
C     UPRE HOLDS COEFFICIENTS FOR SUBSEQUENT HEIGHTS BY PREP/SPECIES
C     SITE PREP--> NONE      MECH       BURN      ROAD
C
      DATA UPRE/   0.0,   0.20729,   0.18491,  0.11864 /
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      IDANUW = ISER
C----------
      N=INT(DELAY+0.5)
      IF(N.LT.-3) N=-3
      DELAY=FLOAT(N)
      ITIME=INT(TIME+0.5)
      IF(N.GT.ITIME) DELAY=TIME
      AGE=TIME-DELAY-GENTIM+TRAGE
      IF(AGE.LT.1.0) AGE=1.0
      IAGE=INT(AGE+0.5)
      AGELN=ALOG(AGE)
      BNORM=BNORML(IAGE)
      TRAGE=TIME-DELAY
C
      SELECT CASE (I)      
C----------
C     HEIGHT OF TALLEST SUBSEQUENT SPECIES 1 (WB)
C----------
      CASE (1) 
        HHT = 1.0
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 2 (LM)
C----------
      CASE (2) 
        HHT = 0.5
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 3 (DF)
C----------
      CASE (3) 
        HHT = 2.0
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 4 (PM)
C----------
      CASE (4) 
        HHT = 0.5
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 6 (AS)
C----------
      CASE (6) 
        HHT = 5.0
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 7 (LP)
C----------
      CASE (7) 
        HHT = 3.0
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 5 & 8 (BS, ES)
C----------
      CASE (5,8) 
        HHT = 1.5
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 9 (AF)
C----------
      CASE (9) 
        HHT = 0.75
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 10 (PP)
C     USE PSME/CARU, CAGE, AGSP, FEID, PHMA, ACGL, SYAL, SPBE, SYOR,
C     ARUV, MISC HABITAT TYPE CONSTANT.
C----------
      CASE (10) 
        PN= -1.99480 +1.53946*AGELN -0.00402*BAA -0.14710
     &    +UPRE(IPREP) -0.01155*ELEV
        HHT = EXP(PN +EMSQR*DILATE*BNORM*0.49076)
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 11 (UJ)
C----------
      CASE (11) 
        HHT = 0.5
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 12 (RM)
C----------
      CASE (12) 
        HHT = 0.5
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 13 (BI)
C----------
      CASE (13) 
        HHT = 1.0
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 14 (MM)
C----------
      CASE (14) 
        HHT = 5.0
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 15 (NC)
C----------
      CASE (15) 
        HHT = 10.0
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 16 (MC)
C----------
      CASE (16) 
        HHT = 1.0
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 17 (OS)
C----------
      CASE (17)          
        HHT = 1.0
C----------
C     HEIGHT OF TALLEST SUBS. SPECIES 18 (OH)
C----------
      CASE (18) 
        HHT = 10.0
C                    
      END SELECT  
C
      RETURN
      END 
C**END OF CODE SEGMENT



