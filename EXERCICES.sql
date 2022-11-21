-- QUESTION 1 --
--Quels sont les tickets qui comportent l'article d'ID 500 ? Afficher le numéro de ticket uniquement.
select NUMERO_TICKET as 'N°'
from VENDRE
where ID_ARTICLE = '500'

-- Question 2 --
--Quels sont les les tickets du 15/01/2017 ? Afficher le numéro de ticket et la date.
SELECT        NUMERO_TICKET, DATE_VENTE
FROM            TICKET
WHERE        (DATE_VENTE = CONVERT(DATETIME, '2017-01-15 00:00:00', 102))

-- Question 3 --
--Quels sont les tickets émis du 15/01/2017 au 17/01/2017 ? Afficher le numéro de ticket et la date.
SELECT        NUMERO_TICKET, DATE_VENTE
FROM            TICKET
WHERE DATE_VENTE BETWEEN '15/01/2017' AND '17/01/2017'

-- Question 4 --
--Éditer la liste des articles (Code et nom uniquement) apparaissant sur un ticket à au moins 95 exemplaires.
SELECT DISTINCT       ARTICLE.ID_ARTICLE, ARTICLE.NOM_ARTICLE, VENDRE.QUANTITE
FROM            ARTICLE INNER JOIN
VENDRE on ARTICLE.ID_ARTICLE = VENDRE.ID_ARTICLE
WHERE (VENDRE.QUANTITE >= 95)

SELECT ARTICLE.ID_ARTICLE, ARTICLE.NOM_ARTICLE
FROM ARTICLE INNER JOIN
VENDRE AS VENDRE ON VENDRE.ID_ARTICLE = ARTICLE.ID_ARTICLE
WHERE QUANTITE >= 95
GROUP BY ARTICLE.ID_ARTICLE, NOM_ARTICLE

-- QUESTION 5 --
--Quels sont les tickets émis au mois de mars 2017 ? Afficher le numéro de ticket et la date.
SELECT        NUMERO_TICKET, DATE_VENTE
FROM            TICKET
WHERE DATE_VENTE BETWEEN '01/03/2017' AND '31/03/2017'

-- QUESTION 6 --
--Quels sont les tickets émis au deuxième trimestre 2017 ? Afficher le numéro de ticket et la date.
SELECT        NUMERO_TICKET, DATE_VENTE
FROM            TICKET
WHERE ANNEE = 2017 
AND MONTH(DATE_VENTE) BETWEEN 4 AND 6

-- QUESTION 7 --
--Quels sont les tickets émis au mois de mars et juillet 2017 ? Afficher le numéro de ticket et la date.
SELECT        NUMERO_TICKET, DATE_VENTE
FROM            TICKET
WHERE DATE_VENTE BETWEEN '01/03/2017' AND '31/03/2017' OR DATE_VENTE BETWEEN '01/07/2017' AND '31/07/2017'

-- QUESTION 8 --
--Afficher la liste de toutes les bières classée par couleur. (Afficher code et nom de bière, nom de la couleur)
SELECT ID_ARTICLE, NOM_ARTICLE, ID_COULEUR 
FROM ARTICLE 
WHERE ID_COULEUR IS NOT NULL
ORDER BY ID_COULEUR

-- QUESTION 9 ---
--Afficher la liste des bières n'ayant pas de couleur. (Afficher le code et le nom)
SELECT ID_ARTICLE, NOM_ARTICLE
FROM ARTICLE 
WHERE ID_COULEUR IS NULL

-- QUESTION 10 ---
--Donnez la liste des bières de même couleur et de même type que la bière ayant le code 142.
--(affichez le code et le nom de la bière, le nom de la couleur et le nom du type)
SELECT ID_ARTICLE AS Code, NOM_ARTICLE AS Libellé,
(SELECT NOM_COULEUR FROM COULEUR WHERE ID_COULEUR = A.ID_COULEUR) AS COULEUR,
(SELECT NOM_TYPE FROM TYPEBIERE WHERE ID_TYPE = a.ID_TYPE) as 'Type'
FROM ARTICLE AS A
WHERE ID_COULEUR = (select ID_COULEUR from ARTICLE where ID_ARTICLE = 142)
AND ID_TYPE = (select ID_TYPE from ARTICLE where ID_ARTICLE = 142)

-- QUESTION 11 ---
--Lister pour chaque ticket la quantité totale d'articles vendus. (Classer par quantité décroissante)
select ANNEE, NUMERO_TICKET, SUM(QUANTITE) AS QUANTITE_TOTALE
FROM VENDRE
GROUP BY ANNEE, NUMERO_TICKET
ORDER BY QUANTITE_TOTALE DESC

-- QUESTION 12 ---
--Lister chaque ticket pour lequel la quantité totale d'articles vendus est inférieure à 50. (Classer par quantité croissante)
select ANNEE, NUMERO_TICKET, SUM(QUANTITE) AS Quantite_totale
FROM VENDRE
GROUP BY ANNEE, NUMERO_TICKET
HAVING SUM(QUANTITE) < 50
ORDER BY Quantite_totale ASC

-- QUESTION 13 ---
--Lister chaque ticket pour lequel la quantité totale d'articles vendus est supérieure à 500. (Classer par quantité décroissante)
select ANNEE, NUMERO_TICKET, SUM(QUANTITE) AS Quantite_totale
FROM VENDRE
GROUP BY ANNEE, NUMERO_TICKET
HAVING SUM(QUANTITE) > 500
ORDER BY Quantite_totale DESC

-- QUESTION 14 --
--Lister chaque ticket pour lequel la quantité totale d'articles vendus est supérieure à 500--
--On exclura du total, les ventes de 50 articles et plus. (classer par quantité décroissante)--
select ANNEE, NUMERO_TICKET, SUM(QUANTITE) AS Quantite_totale
FROM VENDRE
WHERE QUANTITE <= 50
GROUP BY ANNEE, NUMERO_TICKET
HAVING SUM(QUANTITE) > 500
ORDER BY Quantite_totale DESC

-- QUESTION 15 --
--Lister les bières de type ‘Trappiste'. (id, nom de la bière, volume et titrage)--
SELECT ID_ARTICLE, NOM_ARTICLE, VOLUME, TITRAGE
FROM ARTICLE
WHERE ID_TYPE = (Select ID_TYPE from TYPEBIERE where NOM_TYPE='Trappiste')

-- QUESTION 16 --
--Lister les marques du continent ‘Afrique'. (id et nom de marque, nom du continent)--
SELECT ID_CONTINENT, NOM_MARQUE, NOM_CONTINENT
FROM MARQUE, CONTINENT
WHERE ID_CONTINENT = (Select ID_CONTINENT from CONTINENT where NOM_CONTINENT='Afrique')

-- QUESTION 17 --
--Lister les bières du continent ‘Afrique'. (ID, Nom et volume)--
SELECT ID_ARTICLE, NOM_ARTICLE, VOLUME FROM ARTICLE WHERE ID_MARQUE IN
	(Select ID_MARQUE from MARQUE where ID_PAYS IN 
			(SELECT ID_PAYS from PAYS where ID_CONTINENT = 
				(select ID_CONTINENT from CONTINENT where NOM_CONTINENT = 'Afrique'
					)
						)
							)

-- QUESTION 18 --
--Lister les tickets (année, numéro de ticket, montant total à payer). En sachant que :--
--on applique un taux de TVA de 20% au montant total hors taxe de chaque ticket--
--Classer par montant décroissant :--
select annee, numero_ticket, "à payer" = convert (float,round(sum (quantite * prix_vente * 1.20 ) ,2)) 
from vendre
group by annee, NUMERO_TICKET
order by "à payer" desc

-- QUESTION 19 --
--Donner le C.A. par année. (Année et Total HT)--
select ANNEE, sum(QUANTITE*PRIX_VENTE) as 'CA HT'
from VENDRE
group by ANNEE
ORDER BY ANNEE

select VENDRE.ANNEE,convert (float,round(SUM( QUANTITE*PRIX_VENTE),2)) as 'CA' from VENDRE
GROUP BY ANNEE
ORDER BY ANNEE ASC

-- QUESTION 20 --
--Lister les quantités vendues de chaque article pour l'année 2017. (Id et nom de l'article, quantité vendue)--
select ID_ARTICLE, NOM_ARTICLE, (select sum(quantite) from VENDRE where ID_ARTICLE = A.ID_ARTICLE and ANNEE = 2017) as 'QTE VENDUES 2017'
from ARTICLE as A

select ARTICLE.ID_ARTICLE, ARTICLE.NOM_ARTICLE, VENDRE.ANNEE, 
"articles vendus" = sum (VENDRE.QUANTITE * ARTICLE.ID_ARTICLE)
from VENDRE
INNER JOIN article on article.ID_ARTICLE = VENDRE.ID_ARTICLE
WHERE VENDRE.ANNEE = '2017'
group by ARTICLE.ID_ARTICLE, ARTICLE.NOM_ARTICLE, VENDRE.ANNEE

-- QUESTION 21 --
--Lister les quantités vendues de chaque article pour les années 2014,2015 ,2016,2017--
select ID_ARTICLE, NOM_ARTICLE, 
(select sum(quantite) from VENDRE where ID_ARTICLE = A.ID_ARTICLE and ANNEE = 2014) as 'QTE VENDUES 2014',
(select sum(quantite) from VENDRE where ID_ARTICLE = A.ID_ARTICLE and ANNEE = 2015) as 'QTE VENDUES 2015',
(select sum(quantite) from VENDRE where ID_ARTICLE = A.ID_ARTICLE and ANNEE = 2016) as 'QTE VENDUES 2016',
(select sum(quantite) from VENDRE where ID_ARTICLE = A.ID_ARTICLE and ANNEE = 2017) as 'QTE VENDUES 2017'
from ARTICLE as A

-- QUESTION 22 --
--Lister les tickets sur lesquels apparaissent un des articles apparaissant aussi sur le ticket 2017-5123. (Anne et Numéro de ticket)--
select DISTINCT v1.ANNEE, v1.NUMERO_TICKET from VENDRE as v1
join VENDRE as v2 on v1.ID_ARTICLE = v2.ID_ARTICLE
where v2.ANNEE = 2017 and v2.NUMERO_TICKET = 5123

-- QUESTION 23 --
--Donner pour chaque Type de bière, la bière la plus vendue en 2017. (Classer par quantité décroissante)
SELECT TYPEBIERE.NOM_TYPE, MAX(VENDRE.QUANTITE) AS 'MAXQTE', VENDRE.ANNEE
FROM TYPEBIERE INNER JOIN
ARTICLE ON TYPEBIERE.ID_TYPE = ARTICLE.ID_TYPE INNER JOIN
VENDRE ON ARTICLE.ID_ARTICLE = VENDRE.ID_ARTICLE
WHERE VENDRE.ANNEE = '2017'
GROUP BY VENDRE.ANNEE, TYPEBIERE.NOM_TYPE
ORDER BY TYPEBIERE.NOM_TYPE DESC

SELECT TYPEBIERE.NOM_TYPE FROM TYPEBIERE

SELECT TB3.ident, TB3.Marque, TB2.NomArticle, Sum(TB2.NombreVendu) AS Total
FROM TB1 JOIN TB2 ON TB1.ID = TB2.Id
JOIN TB1.ID = TB3.ID
WHERE  TB1.ETAT="Valide"
GROUP BY TB3.ident, TB3.Marque, TB2.NomArticle
ORDER BY Total DESC;

-- QUESTION 24 --
--Donner la liste des bières qui n'ont pas été vendues en 2014 ni en 2015. (Id, nom et volume)
select a.id_article, a.NOM_ARTICLE, a.VOLUME from ARTICLE as a 
where not exists (select v.id_article from VENDRE as v
where ANNEE = 2014 and a.ID_ARTICLE = v.ID_ARTICLE) 
and not exists (select v.id_article from VENDRE as v
where ANNEE = 2015 and a.ID_ARTICLE = v.ID_ARTICLE)
order by ID_ARTICLE asc

select * from VENDRE where ANNEE between 2014 and 2015
order by ID_ARTICLE

-- QUESTION 25 --
--Donner la liste des bières qui n'ont pas été vendues en 2014 mais ont été vendues en 2015. (Id, nom et volume)
select a.id_article, a.NOM_ARTICLE, a.VOLUME from ARTICLE as a 
where not exists (select v.id_article from VENDRE as v
where ANNEE = 2014 and a.ID_ARTICLE = v.ID_ARTICLE) 
and  exists (select v.id_article from VENDRE as v
where ANNEE = 2015 and a.ID_ARTICLE = v.ID_ARTICLE)
order by ID_ARTICLE asc

-- QUESTION 26 --
--une requête qui pourra leur donner une vue du CA par couleur et par an. (de 2014 à 2017)

select NOM_COULEUR,
(SELECT sum(VENDRE.QUANTITE*VENDRE.PRIX_VENTE))as'CA 2014',
(SELECT sum(VENDRE.QUANTITE*VENDRE.PRIX_VENTE))as'CA 2015',
(SELECT sum(VENDRE.QUANTITE*VENDRE.PRIX_VENTE))as'CA 2016',
(SELECT sum(VENDRE.QUANTITE*VENDRE.PRIX_VENTE))as'CA 2017'
FROM VENDRE, COULEUR, ARTICLE
WHERE ARTICLE.ID_ARTICLE=VENDRE.ID_ARTICLE AND ARTICLE.ID_COULEUR = COULEUR.ID_COULEUR 
GROUP BY NOM_COULEUR 
ORDER BY NOM_COULEUR ASC