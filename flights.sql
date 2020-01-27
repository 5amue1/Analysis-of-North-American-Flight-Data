--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
-- Dumped by pg_dump version 12.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: all_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.all_data (
    identifier character varying(21) NOT NULL,
    flightdate date NOT NULL,
    airlinecode character varying(2) NOT NULL,
    airlinename character varying(24) NOT NULL,
    flightnum character varying(4) NOT NULL,
    originairportcode character varying(3) NOT NULL,
    origairportname character varying(52) NOT NULL,
    origincityname character varying(30) NOT NULL,
    originstate character varying(2) NOT NULL,
    originstatename character varying(46) NOT NULL,
    destairportcode character varying(3) NOT NULL,
    destairportname character varying(52) NOT NULL,
    destcityname character varying(30) NOT NULL,
    deststate character varying(2) NOT NULL,
    deststatename character varying(46) NOT NULL,
    crsdeptime smallint NOT NULL,
    deptime smallint,
    depdelay smallint,
    crsarrtime smallint NOT NULL,
    arrtime smallint,
    arrdelay smallint,
    cancelled boolean NOT NULL,
    diverted boolean NOT NULL,
    distance smallint NOT NULL
);


ALTER TABLE public.all_data OWNER TO postgres;

--
-- Name: airline_codes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.airline_codes AS
 SELECT DISTINCT all_data.airlinecode AS airline_code,
    all_data.airlinename AS airline_name
   FROM public.all_data
  ORDER BY all_data.airlinecode;


ALTER TABLE public.airline_codes OWNER TO postgres;

--
-- Name: airline_max_delay; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.airline_max_delay AS
 SELECT all_data.airlinename,
    max(all_data.depdelay) AS max_depdelay,
    max(all_data.arrdelay) AS max_arrdelay
   FROM public.all_data
  GROUP BY all_data.airlinename
  ORDER BY (max(all_data.depdelay)) DESC;


ALTER TABLE public.airline_max_delay OWNER TO postgres;

--
-- Name: cancellation_count; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.cancellation_count AS
 SELECT all_data.airlinename,
    count(all_data.cancelled) AS cancellations
   FROM public.all_data
  WHERE (all_data.cancelled = true)
  GROUP BY all_data.airlinename
  ORDER BY (count(all_data.cancelled)) DESC;


ALTER TABLE public.cancellation_count OWNER TO postgres;

--
-- Name: longest_distances; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.longest_distances AS
 SELECT DISTINCT t1.origincityname AS city_1,
    t1.destcityname AS city_2,
    t1.distance
   FROM (public.all_data t1
     LEFT JOIN public.all_data t2 ON ((((t1.origincityname)::text = (t2.destcityname)::text) AND ((t2.origincityname)::text = (t1.destcityname)::text))))
  WHERE ((t1.origincityname)::text < (t2.origincityname)::text)
  ORDER BY t1.distance DESC
 LIMIT 10;


ALTER TABLE public.longest_distances OWNER TO postgres;

--
-- Name: per_airline_count; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.per_airline_count AS
 SELECT all_data.airlinename AS airline_name,
    count(all_data.airlinename) AS airline_count
   FROM public.all_data
  GROUP BY all_data.airlinename
  ORDER BY (count(all_data.airlinename)) DESC;


ALTER TABLE public.per_airline_count OWNER TO postgres;

--
-- Name: top5_airports_departures; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.top5_airports_departures AS
 SELECT all_data.origairportname,
    count(all_data.origairportname) AS no_of_departures
   FROM public.all_data
  WHERE (all_data.deptime IS NOT NULL)
  GROUP BY all_data.origairportname
  ORDER BY (count(all_data.origairportname)) DESC
 LIMIT 5;


ALTER TABLE public.top5_airports_departures OWNER TO postgres;

--
-- Name: all_data all_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.all_data
    ADD CONSTRAINT all_data_pkey PRIMARY KEY (identifier);


--
-- PostgreSQL database dump complete
--

