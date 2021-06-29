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
/*
1. All items have a SellIn value which denotes the number of days we have to sell the item
2. All items have a Quality value which denotes how valuable the item is
3. At the end of each day our system lowers both values for every item
Pretty simple, right? Well this is where it gets interesting:

4. Once the sell by date has passed, Quality degrades twice as fast
5. The Quality of an item is never negative
6. "Aged Brie" actually increases in Quality the older it gets
7. The Quality of an item is never more than 50
8. "Sulfuras", being a legendary item, never has to be sold or decreases in Quality
9. "Backstage passes", like aged brie, increases in Quality as its SellIn value approaches;
   Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but
   Quality drops to 0 after the concert
*/
	-- 3. The quality of all items decreases over time, with the exceptions below
	-- decrement quality for all items except 'Sulfuras', 'Backstage passes to a TAFKAL80ETC concert', and 'Aged Brie'
	-- also ignore any items with a quality of 0
	UPDATE item
	SET
		quality = quality - 1
	WHERE 1=1
		AND ( name <> 'Aged Brie'  AND  name <> 'Backstage passes to a TAFKAL80ETC concert')
		AND quality > 0
		AND name <> 'Sulfuras, Hand of Ragnaros'
	;

	-- 9. Quality increases by two when there are 10 days or less on sellIn
	-- increase quality of 'Backstage passes to a TAFKAL80ETC concert' when quality is less than 50 and
	-- the sellIn date is under 11
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

	-- 9. Quality increases by three when there are 5 days or less in sellIn
	-- increase quality of 'Backstage passes to a TAFKAL80ETC concert' (possibly again) when quality is less than 50 and
	-- the sellIn date is under 6
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

	-- 3. sellIn decrements by one.
	-- decrement all sellIn values except for Sulfuras
	UPDATE item
	SET
		sellIn = sellIn - 1
	WHERE  1=1
	  AND  name <> 'Sulfuras, Hand of Ragnaros'
	;

	-- 4. quality decreases twice as fast when the sellIn date falls below 0
	-- decrement quality for all items except 'Sulfuras', 'Backstage passes to a TAFKAL80ETC concert', and 'Aged Brie'
	-- when sellIn is less than 0 and quality is > 0
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

	-- 9. Quality drops to 0 after the concert has passed
	-- zero out quality for all 'Backstage passes to a TAFKAL80ETC concert'
	-- once the sellIn is less than 0
	UPDATE item
	SET
		quality = quality - quality
	WHERE  1=1
	  AND sellIn < 0
	  AND name <> 'Aged Brie'
	  AND NOT (name <> 'Backstage passes to a TAFKAL80ETC concert')
	;

	-- 6. and 9. 'Aged brie' and 'Backstage passes to a TAFKAL80ETC concert' increase in value the older they get
	-- increase quality of 'Aged Brie' (possibly again) when quality is less than 50 and
	-- the sellIn date is under 0
	UPDATE item
	SET
		quality = quality + 1
	WHERE  1=1
	  AND sellIn < 0
	  AND NOT (name <> 'Aged Brie')
	  AND quality < 50
	  AND name <> 'Sulfuras, Hand of Ragnaros'
	;

   return 1;
end;
$BODY$;

ALTER FUNCTION public.daily_update()
    OWNER TO postgres;
