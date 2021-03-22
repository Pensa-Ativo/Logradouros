Create Tablespace tblDatRegioes dataFile 'C:\ORACLE\ORADATA\ORCL\TBLDATREGIOES.DBF' Size 10 M OnLine;
Create Tablespace tblIdxRegioes dataFile 'C:\ORACLE\ORADATA\ORCL\TBLIDXREGIOES.DBF' Size 10 M OnLine;

create sequence Logradouros.seqPaises              start with 1 increment by 1 nocache;
create sequence Logradouros.seqUnidadesFederativas start with 1 increment by 1 nocache;
create sequence Logradouros.seqMunicipios          start with 1 increment by 1 nocache;

CREATE TABLE Logradouros.Paises
( ID_PAIS number Default Logradouros.seqPaises.NextVal,
   SGL_PAIS char(2),
   NomePAIS varchar2(100),
   NomePOPULAR varchar2(50),
   NumDDI  Char (04)
)
Tablespace tblDatRegioes;
---
CREATE TABLE Logradouros.UnidadesFederativas
( ID_PAIS Integer, 
  ID_UnidadeFederativa   Integer,
  SiglaUnidadeFederativa CHAR(3 BYTE), 
  NomeUnidadeFederativa  VARCHAR2(50 BYTE)
)
Tablespace tblDatRegioes;
---
CREATE TABLE Logradouros.Municipios
( ID_UnidadeFederativa   Integer,
  ID_Municipio           Integer,
  SiglaMunicipio         CHAR(3 BYTE), 
  NomeMunicipio          VARCHAR2(50 BYTE)
)
Tablespace tblDatRegioes;
--
Update Logradouros.Paises
Set id_Pais = Logradouros.seqPaises.NextVal;

Alter table Logradouros.Paises Add constraint PK_Paises Primary Key (ID_PAIS) 
             USING INDEX TABLESPACE tblIdxRegioes;

CREATE INDEX IdxPaises ON Logradouros.Paises(NomePais)
TABLESPACE tblIdxRegioes   STORAGE (INITIAL 20K   NEXT 20k  PCTINCREASE 75);

CREATE UNIQUE INDEX UKPaises ON Logradouros.Paises
( NomePopular,
  NomePais )
TABLESPACE tblIdxRegioes STORAGE (INITIAL 20K NEXT 20k PCTINCREASE 75);
---
Update Logradouros.UnidadesFederativas
Set ID_UnidadeFederativa = Logradouros.seqUnidadesFederativas.NextVal;

Alter table Logradouros.UnidadesFederativas Add constraint PK_UnidadesFederativas Primary Key (ID_UnidadeFederativa) 
             USING INDEX TABLESPACE tblIdxRegioes;

CREATE INDEX IdxUnidadesFederativas ON Logradouros.UnidadesFederativas(NomeUnidadeFederativa)
TABLESPACE tblIdxRegioes   STORAGE (INITIAL 20K   NEXT 20k  PCTINCREASE 75);

CREATE UNIQUE INDEX UK_UnidadesFederativas ON Logradouros.UnidadesFederativas
( NomeUnidadeFederativa,
  ID_UnidadeFederativa )
TABLESPACE tblIdxRegioes STORAGE (INITIAL 20K NEXT 20k PCTINCREASE 75);

---
Update Logradouros.Municipios
Set ID_Municipio = Logradouros.seqMunicipios.NextVal;

Update Logradouros.Municipios 
Set ID_UnidadeFederativa = (Select ID_UnidadeFederativa
                            From UnidadesFederativas UF
							Where uf.SiglaUnidadeFederativa = Municipios.SiglaUnidadeFederativa);

Alter table Logradouros.Municipios Add constraint PK_Municipioss Primary Key (ID_Municipio) 
             USING INDEX TABLESPACE tblIdxRegioes;

CREATE INDEX IdxMunicipios ON Logradouros.Municipios (NomeMunicipio)
TABLESPACE tblIdxRegioes   STORAGE (INITIAL 20K   NEXT 20k  PCTINCREASE 75);

CREATE UNIQUE INDEX UK_UnidadesFederativas ON Logradouros.UnidadesFederativas
( NomeMunicipio,
  ID_UnidadeFederativa )
TABLESPACE tblIdxRegioes STORAGE (INITIAL 20K NEXT 20k PCTINCREASE 75);
---

  GRANT SELECT ON "LOGRADOUROS"."ESTADOS" TO "MARCIO";

