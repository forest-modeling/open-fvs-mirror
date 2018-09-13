      FUNCTION BRATIO(IS,D,H)
      IMPLICIT NONE
C-----
C PN $Id$
C-------
C
C FUNCTION TO COMPUTE BARK RATIOS.  THIS ROUTINE IS VARIANT SPECIFIC
C AND EACH VARIANT USES ONE OR MORE OF THE ARGUMENTS PASSED TO IT.
C
C  SPECIES LIST CODES: SEQUENCE NO.-SPECIES ALPHA CODE-FIA NO.
C
C   1-SF-011, 2-WF-015, 3-GF-017  4-AF-019, 5-RF-020, 6-SS-098,
C   7-NF-022, 8-YC-042, 9-IC-081,10-ES-093,11-LP-108,12-JP-116,
C  13-SP-117,14-WP-119,15-PP-122,16-DF-202,17-RW-211,18-RC-242,
C  19-WH-263,20-MH-264,21-BM-312,22-RA-351,23-WA-352,24-PB-376,
C  25-GC-431,26-AS-746,27-CW-747,28-WO-815,29-J0-060,30-LL-072,
C  31-WB-101,32-KP-103,33-PY-231,34-DG-492,35-HT-500,36-CH-764,
C  37-WI-920,   ---   ,39-OT-999
C----------

      REAL BARKB(4,15),H,D,BRATIO,DIB
      INTEGER JBARK(39),IS
      REAL RDANUW
C
      DATA JBARK/
     &  2,  2,  2,  2,  2, 11,  2,  5,  5,  9,
     & 10,  4,  4,  4,  3,  1,  5, 12, 13, 12,
     &  6, 14, 14,  6,  7, 14, 14,  8, 12, 10,
     & 15, 15, 15, 14, 14, 14, 14, 10, 10/
C----------
C  MASTER SPECIES
C  202=DF, 015=WF, 122=PP, 116=JP, 081=IC, 312=BM, 431=GC, 815=WO,
C  093=ES, 108=LP, 098=SS, 242=RC, 263=WH, 351=RA, 001=OTHER SOFTWOODS
C
C  NOTE: COEFFICIENTS FOR SPECIES 312 & 431 IN PILLSBURY &
C  KIRKLEY ARE METRIC. INTERCEPT IS DIVIDED BY 2.54 TO CONVERT THESE
C  EQUATIONS TO ENGLISH.
C----------
      DATA BARKB/
     & 202.,  0.903563,  0.989388, 1.,
     &  15.,  0.904973,  1.0     , 1.,
     & 122.,  0.809427,  1.016866, 1.,
     & 116.,  0.859045,  1.0     , 1.,
     &  81.,  0.837291,  1.0     , 1.,
     & 312.,  0.08360 ,  0.94782 , 2.,
     & 431.,  0.15565 ,  0.90182 , 2.,
     & 815.,  0.8558  ,  1.0213 ,  1.,
     &  93.,   .9     ,  0.0     , 3.,
     & 108.,   .9     ,  0.0     , 3.,
     &  98.,  0.958330,  1.0     , 1.,
     & 242.,  0.949670,  1.0     , 1.,
     & 263.,  0.933710,  1.0     , 1.,
     & 351.,  0.075256,  0.94373 , 2.,
     & 001.,  0.933290,  1.0     , 1./
C----------
C BARK COEFS
C  202,15,122,116,81   FROM WALTERS ET.AL. RES BULL 50  TABLE 2
C  312,431             FROM PILLSBURY AND KIRKLEY RES NOTE PNW 414
C  93,108,242,263      FROM WYKOFF ET.AL. RES PAPER INT 133  TABLE 7
C  98                  FROM HARLOW & HARRAR, TEXTBOOK OF DENDRO PG 129
C  351                 AVERAGE OF 312,361,431 VALUES FROM PILLSBURY &
C                      KIRKLEY TABLE 2, PLUS INFO FROM HARLOW & HARRAR
C  001                 AVERAGE OF 019,081,093,108,119
C  815                 FROM GOULD AND HARRINGTON
C
C  EQUATION TYPES
C  1  DIB = a * DOB ** b
C  2  DIB = a + bDOB
C  3  DIB = a*DOB
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      RDANUW = H
C
      IF (D .GT. 0) THEN
        IF(BARKB(4,JBARK(IS)) .EQ. 1.)THEN
          DIB=BARKB(2,JBARK(IS))*D**BARKB(3,JBARK(IS))
          BRATIO=DIB/D
        ELSEIF (BARKB(4,JBARK(IS)) .EQ. 2.)THEN
          DIB=BARKB(2,JBARK(IS)) + BARKB(3,JBARK(IS))*D
          BRATIO=DIB/D
        ELSEIF (BARKB(4,JBARK(IS)) .EQ. 3.)THEN
          BRATIO=BARKB(2,JBARK(IS))
        ELSE
          BRATIO= 0.9
        ENDIF
      ELSE
        BRATIO = 0.99
      ENDIF

C
      IF(BRATIO .GT. 0.99) BRATIO= 0.99
      IF(BRATIO .LT. 0.80) BRATIO= 0.80
C
      RETURN
      END
