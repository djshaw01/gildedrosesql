CREATE TABLE IF NOT EXISTS public.quality_params
(
    name text COLLATE pg_catalog."default",
    product_category text COLLATE pg_catalog."default",
    quality_delta integer,
    quality_min integer,
    quality_max integer
)

TABLESPACE pg_default;

ALTER TABLE public.quality_params
    OWNER to postgres;