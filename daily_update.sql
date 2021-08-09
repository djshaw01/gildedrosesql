-- FUNCTION: public.daily_update()

-- DROP FUNCTION public.daily_update();

CREATE OR REPLACE FUNCTION public.daily_update(
	)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin

	UPDATE item
	SET
		quality = quality - 1
	WHERE 1=1
		AND ( name <> 'Aged Brie'  AND  name <> 'Backstage passes to a TAFKAL80ETC concert')
		AND ( name <> 'Sulfuras, Hand of Ragnaros' AND name NOT LIKE '%Conjured%')
		AND quality > 0;
		 
	UPDATE item
	SET
		quality = quality + 1
	WHERE  1=1	                                 
	  AND  name = 'Backstage passes to a TAFKAL80ETC concert'
	  AND quality < 50
	  AND sellIn < 11
	  AND quality < 50
	;

	UPDATE item
	SET
		quality = quality + 1
	WHERE  1=1
	  AND name = 'Backstage passes to a TAFKAL80ETC concert'
	  AND quality < 50
	  AND sellIn < 6
	  AND quality < 50
	;

	UPDATE item
	SET
		sellIn = sellIn - 1
	WHERE  1=1
	  AND  name <> 'Sulfuras, Hand of Ragnaros'
	;

	UPDATE item
	SET
		quality = quality - 1
	WHERE  1=1
	  AND sellIn < 0
	  AND name <> 'Aged Brie'
	  AND name <> 'Backstage passes to a TAFKAL80ETC concert'
	  AND quality > 0
	  AND name <> 'Sulfuras, Hand of Ragnaros'
	;

	UPDATE item
	SET
		quality = quality - quality
	WHERE  1=1
	  AND sellIn < 0
	  AND name = 'Backstage passes to a TAFKAL80ETC concert'
	;

	UPDATE item
	SET
		quality = quality + 1
	WHERE  1=1
	  AND (name = 'Aged Brie' OR name = 'Backstage passes to a TAFKAL80ETC concert')
	  AND quality < 50
	;
	
	UPDATE item
	SET
		quality = quality - 2
	WHERE  1=1
	  AND name LIKE 'Conjured%'
	  AND quality > 0
	;

   return 1;
end;
$BODY$;

ALTER FUNCTION public.daily_update()
    OWNER TO postgres;
