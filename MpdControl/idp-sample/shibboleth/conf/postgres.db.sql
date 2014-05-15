 CREATE EXTENSION hstore
  SCHEMA public
  VERSION "1.0";
 CREATE EXTENSION pgcrypto
  SCHEMA public
  VERSION "1.0";
 CREATE EXTENSION plpgsql
  SCHEMA pg_catalog
  VERSION "1.0";
 CREATE EXTENSION uuid-ossp
  SCHEMA public
  VERSION "1.0";



--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: attributes; Type: TABLE; Schema: public; Owner: idp; Tablespace: 
--

CREATE TABLE attributes (
    "AttributeID" bigint NOT NULL,
    "AttributeType" character varying NOT NULL,
    "Name" character varying NOT NULL,
    "ValueType" character varying NOT NULL
);


ALTER TABLE public.attributes OWNER TO idp;

--
-- Name: attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: idp
--

CREATE SEQUENCE attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attributes_id_seq OWNER TO idp;

--
-- Name: attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idp
--

ALTER SEQUENCE attributes_id_seq OWNED BY attributes."AttributeID";


--
-- Name: federatedusers; Type: TABLE; Schema: public; Owner: idp; Tablespace: 
--

CREATE TABLE federatedusers (
    "FederatedUserID" bigint NOT NULL,
    "Issuer" character varying,
    "PersistentID" character varying
);


ALTER TABLE public.federatedusers OWNER TO idp;

--
-- Name: federatedusers_id_seq; Type: SEQUENCE; Schema: public; Owner: idp
--

CREATE SEQUENCE federatedusers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.federatedusers_id_seq OWNER TO idp;

--
-- Name: federatedusers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idp
--

ALTER SEQUENCE federatedusers_id_seq OWNED BY federatedusers."FederatedUserID";


--
-- Name: roles; Type: TABLE; Schema: public; Owner: idp; Tablespace: 
--

CREATE TABLE roles (
    "RoleID" bigint NOT NULL,
    "FriendlyName" character varying NOT NULL,
    "Data" hstore
);


ALTER TABLE public.roles OWNER TO idp;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: idp
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO idp;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idp
--

ALTER SEQUENCE roles_id_seq OWNED BY roles."RoleID";


--
-- Name: shibpid; Type: TABLE; Schema: public; Owner: idpstoredwrite; Tablespace: 
--

CREATE TABLE shibpid (
    localentity character varying NOT NULL,
    peerentity character varying NOT NULL,
    principalname character varying NOT NULL,
    localid character varying NOT NULL,
    persistentid character varying NOT NULL,
    peerprovidedid character varying,
    creationdate timestamp without time zone NOT NULL,
    deactivationdate timestamp without time zone
);


ALTER TABLE public.shibpid OWNER TO idpstoredwrite;

--
-- Name: users; Type: TABLE; Schema: public; Owner: idp; Tablespace: 
--

CREATE TABLE users (
    "UserID" bigint NOT NULL,
    "Email" character varying NOT NULL,
    "PasswordSalt" character varying,
    "PasswordVersion" integer NOT NULL,
    "PasswordHash" character varying NOT NULL,
    "UniqueID" uuid NOT NULL,
    "Disabled" boolean DEFAULT false NOT NULL
);


ALTER TABLE public.users OWNER TO idp;

--
-- Name: users_UserID_seq; Type: SEQUENCE; Schema: public; Owner: idp
--

CREATE SEQUENCE "users_UserID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."users_UserID_seq" OWNER TO idp;

--
-- Name: users_UserID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idp
--

ALTER SEQUENCE "users_UserID_seq" OWNED BY users."UserID";


--
-- Name: users_to_attributes; Type: TABLE; Schema: public; Owner: idp; Tablespace: 
--

CREATE TABLE users_to_attributes (
    "MappingID" bigint NOT NULL,
    "UserID" bigint,
    "FederatedUserID" bigint,
    "AttributeID" bigint NOT NULL,
    "AttributeValue" character varying
);


ALTER TABLE public.users_to_attributes OWNER TO idp;

--
-- Name: users_to_attributes_MappingID_seq; Type: SEQUENCE; Schema: public; Owner: idp
--

CREATE SEQUENCE "users_to_attributes_MappingID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."users_to_attributes_MappingID_seq" OWNER TO idp;

--
-- Name: users_to_attributes_MappingID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idp
--

ALTER SEQUENCE "users_to_attributes_MappingID_seq" OWNED BY users_to_attributes."MappingID";


--
-- Name: users_to_roles; Type: TABLE; Schema: public; Owner: idp; Tablespace: 
--

CREATE TABLE users_to_roles (
    "RoleID" integer NOT NULL,
    "UserID" integer,
    "FederatedUserID" integer,
    "MappingID" bigint NOT NULL,
    CONSTRAINT users_to_roles_check CHECK ((("UserID" IS NOT NULL) OR ("FederatedUserID" IS NOT NULL)))
);


ALTER TABLE public.users_to_roles OWNER TO idp;

--
-- Name: users_to_roles_MappingID_seq; Type: SEQUENCE; Schema: public; Owner: idp
--

CREATE SEQUENCE "users_to_roles_MappingID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."users_to_roles_MappingID_seq" OWNER TO idp;

--
-- Name: users_to_roles_MappingID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: idp
--

ALTER SEQUENCE "users_to_roles_MappingID_seq" OWNED BY users_to_roles."MappingID";


--
-- Name: AttributeID; Type: DEFAULT; Schema: public; Owner: idp
--

ALTER TABLE ONLY attributes ALTER COLUMN "AttributeID" SET DEFAULT nextval('attributes_id_seq'::regclass);


--
-- Name: FederatedUserID; Type: DEFAULT; Schema: public; Owner: idp
--

ALTER TABLE ONLY federatedusers ALTER COLUMN "FederatedUserID" SET DEFAULT nextval('federatedusers_id_seq'::regclass);


--
-- Name: RoleID; Type: DEFAULT; Schema: public; Owner: idp
--

ALTER TABLE ONLY roles ALTER COLUMN "RoleID" SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: UserID; Type: DEFAULT; Schema: public; Owner: idp
--

ALTER TABLE ONLY users ALTER COLUMN "UserID" SET DEFAULT nextval('"users_UserID_seq"'::regclass);


--
-- Name: MappingID; Type: DEFAULT; Schema: public; Owner: idp
--

ALTER TABLE ONLY users_to_attributes ALTER COLUMN "MappingID" SET DEFAULT nextval('"users_to_attributes_MappingID_seq"'::regclass);


--
-- Name: MappingID; Type: DEFAULT; Schema: public; Owner: idp
--

ALTER TABLE ONLY users_to_roles ALTER COLUMN "MappingID" SET DEFAULT nextval('"users_to_roles_MappingID_seq"'::regclass);


--
-- Name: UniqueID; Type: CONSTRAINT; Schema: public; Owner: idp; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT "UniqueID" UNIQUE ("UniqueID");


--
-- Name: UserEmail_uniq; Type: CONSTRAINT; Schema: public; Owner: idp; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT "UserEmail_uniq" UNIQUE ("Email");


--
-- Name: UserID_pk; Type: CONSTRAINT; Schema: public; Owner: idp; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT "UserID_pk" PRIMARY KEY ("UserID");


--
-- Name: attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: idp; Tablespace: 
--

ALTER TABLE ONLY attributes
    ADD CONSTRAINT attributes_pkey PRIMARY KEY ("AttributeID");


--
-- Name: federatedusers_pkey; Type: CONSTRAINT; Schema: public; Owner: idp; Tablespace: 
--

ALTER TABLE ONLY federatedusers
    ADD CONSTRAINT federatedusers_pkey PRIMARY KEY ("FederatedUserID");


--
-- Name: pk_id; Type: CONSTRAINT; Schema: public; Owner: idp; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT pk_id PRIMARY KEY ("RoleID");


--
-- Name: users_to_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: idp; Tablespace: 
--

ALTER TABLE ONLY users_to_attributes
    ADD CONSTRAINT users_to_attributes_pkey PRIMARY KEY ("MappingID");


--
-- Name: users_to_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: idp; Tablespace: 
--

ALTER TABLE ONLY users_to_roles
    ADD CONSTRAINT users_to_roles_pkey PRIMARY KEY ("MappingID");


--
-- Name: fk_federateduser_id; Type: INDEX; Schema: public; Owner: idp; Tablespace: 
--

CREATE INDEX fk_federateduser_id ON users_to_roles USING btree ("FederatedUserID");


--
-- Name: fk_user_id; Type: INDEX; Schema: public; Owner: idp; Tablespace: 
--

CREATE INDEX fk_user_id ON users_to_roles USING btree ("UserID");


--
-- Name: localentity; Type: INDEX; Schema: public; Owner: idpstoredwrite; Tablespace: 
--

CREATE INDEX localentity ON shibpid USING btree (localentity, peerentity, localid, deactivationdate);


--
-- Name: persistentid; Type: INDEX; Schema: public; Owner: idpstoredwrite; Tablespace: 
--

CREATE INDEX persistentid ON shibpid USING btree (persistentid, deactivationdate);


--
-- Name: users_to_attributes_AttributeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: idp
--

ALTER TABLE ONLY users_to_attributes
    ADD CONSTRAINT "users_to_attributes_AttributeID_fkey" FOREIGN KEY ("AttributeID") REFERENCES attributes("AttributeID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_to_attributes_FederatedUserID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: idp
--

ALTER TABLE ONLY users_to_attributes
    ADD CONSTRAINT "users_to_attributes_FederatedUserID_fkey" FOREIGN KEY ("FederatedUserID") REFERENCES federatedusers("FederatedUserID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_to_attributes_UserID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: idp
--

ALTER TABLE ONLY users_to_attributes
    ADD CONSTRAINT "users_to_attributes_UserID_fkey" FOREIGN KEY ("UserID") REFERENCES users("UserID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_to_roles_federateduser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: idp
--

ALTER TABLE ONLY users_to_roles
    ADD CONSTRAINT users_to_roles_federateduser_id_fkey FOREIGN KEY ("FederatedUserID") REFERENCES federatedusers("FederatedUserID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_to_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: idp
--

ALTER TABLE ONLY users_to_roles
    ADD CONSTRAINT users_to_roles_user_id_fkey FOREIGN KEY ("UserID") REFERENCES users("UserID");


--
-- Name: attributes; Type: ACL; Schema: public; Owner: idp
--

REVOKE ALL ON TABLE attributes FROM PUBLIC;
REVOKE ALL ON TABLE attributes FROM idp;
GRANT ALL ON TABLE attributes TO idp;
GRANT SELECT ON TABLE attributes TO idpread;


--
-- Name: roles; Type: ACL; Schema: public; Owner: idp
--

REVOKE ALL ON TABLE roles FROM PUBLIC;
REVOKE ALL ON TABLE roles FROM idp;
GRANT ALL ON TABLE roles TO idp;
GRANT SELECT ON TABLE roles TO idpread;


--
-- Name: users.UserID; Type: ACL; Schema: public; Owner: idp
--

REVOKE ALL("UserID") ON TABLE users FROM PUBLIC;
REVOKE ALL("UserID") ON TABLE users FROM idp;
GRANT SELECT("UserID") ON TABLE users TO idpread;


--
-- Name: users.Email; Type: ACL; Schema: public; Owner: idp
--

REVOKE ALL("Email") ON TABLE users FROM PUBLIC;
REVOKE ALL("Email") ON TABLE users FROM idp;
GRANT SELECT("Email") ON TABLE users TO idpread;


--
-- Name: users.UniqueID; Type: ACL; Schema: public; Owner: idp
--

REVOKE ALL("UniqueID") ON TABLE users FROM PUBLIC;
REVOKE ALL("UniqueID") ON TABLE users FROM idp;
GRANT SELECT("UniqueID") ON TABLE users TO idpread;


--
-- Name: users.Disabled; Type: ACL; Schema: public; Owner: idp
--

REVOKE ALL("Disabled") ON TABLE users FROM PUBLIC;
REVOKE ALL("Disabled") ON TABLE users FROM idp;
GRANT SELECT("Disabled") ON TABLE users TO idpread;


--
-- Name: users_to_attributes; Type: ACL; Schema: public; Owner: idp
--

REVOKE ALL ON TABLE users_to_attributes FROM PUBLIC;
REVOKE ALL ON TABLE users_to_attributes FROM idp;
GRANT ALL ON TABLE users_to_attributes TO idp;
GRANT SELECT ON TABLE users_to_attributes TO idpread;


--
-- Name: users_to_roles; Type: ACL; Schema: public; Owner: idp
--

REVOKE ALL ON TABLE users_to_roles FROM PUBLIC;
REVOKE ALL ON TABLE users_to_roles FROM idp;
GRANT ALL ON TABLE users_to_roles TO idp;
GRANT SELECT ON TABLE users_to_roles TO idpread;


--
-- PostgreSQL database dump complete
--

