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

/*	UPDATE item
	SET
		quality = quality - 1
	WHERE 1=1
		AND ( name <> 'Aged Brie'  AND  name <> 'Backstage passes to a TAFKAL80ETC concert')
		AND quality > 0
		AND name <> 'Sulfuras, Hand of Ragnaros'
	;

	UPDATE item
	SET
		quality = quality + 1
	WHERE  1=1
	  AND  NOT  ( name <> 'Aged Brie'  AND  name <> 'Backstage passes to a TAFKAL80ETC concert')
	  AND quality < 50
	  AND name = 'Backstage passes to a TAFKAL80ETC concert'
	  AND sellIn < 11
	  AND quality < 50
	;

	UPDATE item
	SET
		quality = quality + 1
	WHERE  1=1
	  AND  NOT  ( name <> 'Aged Brie'  AND  name <> 'Backstage passes to a TAFKAL80ETC concert')
	  AND quality < 50
	  AND name = 'Backstage passes to a TAFKAL80ETC concert'
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
	  AND name <> 'Aged Brie'
	  AND NOT (name <> 'Backstage passes to a TAFKAL80ETC concert')
	;

	UPDATE item
	SET
		quality = quality + 1
	WHERE  1=1
	  AND sellIn < 0
	  AND NOT (name <> 'Aged Brie')
	  AND quality < 50
	  AND name <> 'Sulfuras, Hand of Ragnaros'
	;
	
	UPDATE item
	SET
		quality = quality - 2
	WHERE  1=1
	  --AND sellIn < 0
	  AND quality > 0
	  AND name = 'Conjured'
	;
*/

	update item
	set 
		quality = quality + quality_params.quality_delta
	from quality_params	
	where 1=1
	and item.name = quality_params.name
	and item.quality>=quality_params.quality_min
	and item.quality<=quality_params.quality_max;
	
   return 1;
end;
$BODY$;

ALTER FUNCTION public.daily_update()
    OWNER TO postgres;
