      SUBROUTINE DUBSCR(ISPC,D,H,BA,CR,TPCCF,AVH,TMAI)
      IMPLICIT NONE
C----------
C  **DUBSCR--NI23   DATE OF LAST REVISION:  06/22/10
C----------
C  THIS SUBROUTINE CALCULATES CROWN RATIOS FOR TREES INSERTED BY
C  THE REGENERATION ESTABLISHMENT MODEL.  IT ALSO DUBS CROWN RATIOS
C  FOR TREES IN THE INVENTORY THAT ARE MISSING CROWN RATIO
C  MEASUREMENTS AND ARE LESS THAN 3.0 INCHES DBH.  FINALLY, IT IS
C  USED TO REPLACE CROWN RATIO ESTIMATES FOR ALL TREES THAT
C  CROSS THE THRESHOLD BETWEEN THE SMALL AND LARGE TREE MODELS.
C----------
C  SPECIES EXPANSION: 
C  WB USE COEFFICIENTS FOR L
C  LM AND PY USE COEFFICIENTS FROM TT FOR LM
C  LL USE COEFFICIENTS FOR AF
C  AS, MM, PB USE COEFFIECIENTS FOR AS FROM UT
C  OS USE COEFFEICIENTS FOR MH
C  CO, OH DO NOT USE THIS ROUTINE
C  PI, JU DO NOT USE THIS ROUTINE
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
COMMONS
C----------
      EXTERNAL RANN
      REAL BCR0(MAXSP),BCR1(MAXSP),BCR2(MAXSP),BCR3(MAXSP),
     &          BCR5(MAXSP),BCR6(MAXSP),BCR8(MAXSP),BCR9(MAXSP),
     &          BCR10(MAXSP),CRSD(MAXSP)
      REAL TMAI,AVH,TPCCF,CR,BA,H,D,SD,FCR,BACHLO
      INTEGER ISPC
C
      DATA BCR0/
     &  -0.44316,-0.83965,-0.89122,-0.62646,-0.49548, 0.11847,
     &  -0.32466,-0.92007,-0.89014,-0.17561,-0.49548,
     &  -0.83965,-1.66949,-0.89014,      0.,      0.,-1.669490,
     &  -0.426688,      0.,-.426688,-.426688,      0.,-0.49548/
      DATA BCR1/
     &  -0.48446,-0.16106,-0.18082,-0.06141, 0.00012,-0.39305,
     &  -0.20108,-0.22454,-0.18026,-0.33847, 0.00012,
     &  -0.16106,-0.209765,-.18026,     0.0,     0.0,-.209765,
     &  -.093105,      0.,-.093105,-.093105,      0., .00012/
      DATA BCR2/
     &   0.05825, 0.04161, 0.05186, 0.02360, 0.00362, 0.02783,
     &   0.04219, 0.03248, 0.02233, 0.05699, 0.00362,
     &   0.04161,     0.0, 0.02233,     0.0,     0.0,     0.0,
     &   .022409,      0., .022409, .022409,      0., 0.00362/
      DATA BCR3/
     &   0.00513, 0.00602, 0.00454, 0.00505, 0.00456, 0.00626,
     &   0.00436, 0.00620, 0.00614, 0.00692, 0.00456,
     &   0.00602, .003359, 0.00614,     0.0,     0.0, .003359,
     &   .002633,      0., .002633, .002633,      0., 0.00456/
      DATA BCR5/
     &   12*0.0,0.011032,     0.0,     0.0,     0.0,0.011032,
     &    6*0.0/
      DATA BCR6/
     &   11*0.0,    6*0.0,-.045532,     0.0,-.045532,-.045532,
     &      0.0,      0.0/
      DATA BCR8/
     &   12*0.0,0.017727,      0.0,     0.0,     0.0,0.017727,
     &    6*0.0/
      DATA BCR9/
     &   12*0.0,-.000053,      0.0,     0.0,     0.0,-.000053,
     &  .000022,      0., 0.000022,0.000022,      0.,     0.0/
      DATA BCR10/
     &   12*0.0, .014098,      0.0,     0.0,     0.0,0.014098,
     & -.013115,      0., -.013115,-.013115,      0.,     0.0/
      DATA CRSD/
     &  0.9476,  0.7396,  0.8706,  0.9203,  0.9450,  0.8012,
     &  0.7707,  0.9721,  0.8871,  0.8866,  0.9450,
     &  0.7396,  0.5000,  0.8871,      0.,      0.,  0.5000,
     &  0.9310,      0.,  0.9310,  0.9310,      0.,  0.9450/
C----------
C  EXPECTED CROWN RATIO IS A FUNCTION OF SPECIES, DBH, HEIGHT, AND
C  BASAL AREA.  THE MODEL IS BASED ON THE LOGISTIC FUNCTION,
C  AND RETURNS A VALUE BETWEEN ZERO AND ONE.
C----------
      CR=BCR0(ISPC) + BCR1(ISPC)*D + BCR2(ISPC)*H + BCR3(ISPC)*BA
     &   + BCR5(ISPC)*TPCCF + BCR6(ISPC)*(AVH/H) + BCR8(ISPC)*AVH
     &   + BCR9(ISPC)*(BA*TPCCF) + BCR10(ISPC)*TMAI
C----------
C  A RANDOM ERROR IS ASSIGNED TO THE CROWN RATIO PREDICTION
C  PRIOR TO THE LOGISTIC TRANSFORMATION.  LINEAR REGRESSION
C  WAS USED TO FIT THE MODEL AND THE ELEMENTS OF CRSD ARE THE
C  STANDARD ERRORS FOR THE LINEARIZED MODEL BY SPECIES.
C----------
      SD=CRSD(ISPC)
   10 CONTINUE
      FCR=0.0
      IF (DGSD.GE.1.0) FCR=BACHLO(0.0,SD,RANN)
      IF(ABS(FCR).GT.SD) GO TO 10
      IF(ABS(CR+FCR).GE.86.)CR=86.
      CR=1.0/(1.0 + EXP(CR+FCR))
      IF(CR.LT.0.05) CR=0.05
      IF(CR.GT.0.95) CR=0.95
      RETURN
      END
