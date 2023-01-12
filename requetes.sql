/* 1 */

SELECT NOM,PRENOM FROM PERSONNEL WHERE POSTE='MEDECIN';  

/* 2 */

SELECT SERVICEH.NOM,COUNT(PERSONNEL.INSEE) AS NB_INFIRMIER
FROM ((PERSONNEL INNER JOIN AFFECTATION ON PERSONNEL.INSEE = AFFECTATION.INSEE) INNER JOIN SERVICEH ON AFFECTATION.NUMERO = SERVICEH.NUMERO )
WHERE PERSONNEL.POSTE = 'INFIRMIER'
GROUP BY SERVICEH.NOM ;  

/* 3 */

SELECT PATIENT.NOM FROM PATIENT INNER JOIN VISITE ON PATIENT.INSEE = VISITE.INSEE_PA
INNER JOIN PATHOLOGIE ON PATHOLOGIE.CODE = VISITE.PCODE
WHERE PATHOLOGIE.NOM = 'DIABETE'
ORDER BY DATE_A ASC ;  

/* 4 */

SELECT COUNT(PA_INSEE) AS PATIENT_CARDIOLOGIE
FROM SERVICEH INNER JOIN INTERVENTION ON SERVICEH.NUMERO = INTERVENTION.CNUMSERVICE
WHERE SERVICEH.NOM = 'CARDIOLOGIE' AND EXTRACT(YEAR FROM INTERVENTION.I_DATE)=2015;  

/* 5 */

SELECT MAX(DATE_S - DATE_A) AS DUREE_MAX FROM VISITE WHERE DATE_A > '01/01/2017';  

/* 6 */

SELECT PERSONNEL.NOM FROM PERSONNEL 
INNER JOIN AFFECTATION ON PERSONNEL.INSEE = AFFECTATION.INSEE 
INNER JOIN SERVICEH ON AFFECTATION.NUMERO = SERVICEH.NUMERO  
WHERE SERVICEH.NOM = 'CHIRURGIE' AND PERSONNEL.POSTE = 'MEDECIN' AND PERSONNEL.NOM=(
    SELECT PERSONNEL.NOM FROM PERSONNEL INNER JOIN AFFECTATION ON PERSONNEL.INSEE = AFFECTATION.INSEE INNER JOIN SERVICEH ON AFFECTATION.NUMERO = SERVICEH.NUMERO  
    WHERE SERVICEH.NOM = 'CARDIOLOGIE' AND PERSONNEL.POSTE = 'MEDECIN');  

/* 7 */

SELECT PATIENT.NOM , DATE_A FROM INTERVENTION INNER JOIN PATIENT ON INTERVENTION.PA_INSEE = PATIENT.INSEE INNER JOIN VISITE ON VISITE.INSEE_PA = PATIENT.INSEE
WHERE INTERVENTION.PE_INSEE IN (SELECT INSEE FROM PERSONNEL WHERE PERSONNEL.PRENOM = 'RACHOUL' ) AND VISITE.PCODE = (SELECT CODE FROM PERSONNEL INNER JOIN AFFECTATION ON PERSONNEL.INSEE = AFFECTATION.INSEE INNER JOIN PATHOLOGIE ON AFFECTATION.NUMERO = PATHOLOGIE.SCODE WHERE PRENOM = 'RACHOUL')
ORDER BY DATE_A;  

/* 8 */

 SELECT CSALLE AS NUMSALLE, COUNT(PA_INSEE) NBSOIN  FROM INTERVENTION WHERE CNUMSERVICE = (SELECT NUMERO FROM SERVICEH WHERE SERVICEH.NOM = 'PEDIATRIE')
AND EXTRACT(YEAR FROM I_DATE) = 2020
GROUP BY CSALLE 
ORDER BY COUNT(PA_INSEE) DESC
;  


/* 9 */

SELECT NOM , COUNT(PE_INSEE) AS SOIN2015 FROM INTERVENTION INNER JOIN PERSONNEL ON INTERVENTION.PE_INSEE = PERSONNEL.INSEE WHERE EXTRACT(YEAR FROM INTERVENTION.I_DATE) = 2015 GROUP BY NOM;  

/* 10 */

 SELECT
    CASE 
     WHEN COUNT(CASE WHEN INTERVENTION.RESULTAT  = 'POSITIF' then 'OUI' ELSE NULL END) > COUNT(CASE WHEN INTERVENTION.RESULTAT  = 'NEGATIF' then 'NON' ELSE NULL END) THEN 'OUI'
     WHEN COUNT(CASE WHEN INTERVENTION.RESULTAT  = 'POSITIF' then 'OUI' ELSE NULL END) > COUNT(CASE WHEN INTERVENTION.RESULTAT  = 'NEGATIF' then 'NON' ELSE NULL END) THEN 'NON'
     ELSE 'AUCUNE INTERVENTION DE CE TYPE'

END AS RESULTATS
from INTERVENTION
WHERE INTERVENTION.SNOM='GREFFE DE REIN';

/* 11 */

 SELECT SNOM , AVG(INTERVENTION.SCOÛT) FROM INTERVENTION
GROUP BY SNOM
HAVING AVG(INTERVENTION.SCOÛT)>=1000 ; 

/* 12 */

 SELECT  SOIN.NOM,MAX(COÛT) FROM (((PERSONNEL INNER JOIN AFFECTATION ON PERSONNEL.INSEE = AFFECTATION.INSEE)
INNER JOIN PATHOLOGIE ON AFFECTATION.NUMERO = PATHOLOGIE.SCODE)
INNER JOIN SOIN ON PATHOLOGIE.CODE = SOIN.CODE_P)
WHERE POSTE = 'MEDECIN'
GROUP BY SOIN.NOM;  

/* 13 */

 SELECT INSEE_PA, AVG(DATE_S-DATE_A) AS DUREE_MOYENNE FROM VISITE
GROUP BY (INSEE_PA)
HAVING(AVG(DATE_S-DATE_A)>15);

/* 14 */

 SELECT PERSONNEL.NOM, PERSONNEL.PRENOM FROM PERSONNEL INNER JOIN PATIENT ON PERSONNEL.INSEE=PATIENT.INSEE
    INNER JOIN INTERVENTION ON PATIENT.INSEE = INTERVENTION.PA_INSEE WHERE INTERVENTION.SNOM='GREFFE DE REIN' AND EXTRACT(YEAR FROM INTERVENTION.I_DATE)=2020 AND PERSONNEL.POSTE = 'MEDECIN';