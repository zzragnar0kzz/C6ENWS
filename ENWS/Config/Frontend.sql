/* ###########################################################################
    Begin ENWS Frontend configuration
########################################################################### */

-- Reposition the Disaster Intensity slider
UPDATE Parameters SET SortIndex = 85 WHERE Domain = 'RealismRange';

-- Reposition the Resources parameter
UPDATE Parameters SET SortIndex = 235 WHERE Domain = 'Resources';

-- Define the Natural Wonders slider(s), one for each ruleset
INSERT INTO Parameters (Key1, Key2, ParameterId, Name, Description, Domain, ConfigurationGroup, ConfigurationId, Hash, GroupId, SortIndex)
VALUES
    ('Ruleset', 'RULESET_STANDARD', 'NaturalWonderCount', 'LOC_NATURAL_WONDER_COUNT_NAME', 'LOC_NATURAL_WONDER_COUNT_DESCRIPTION', 'StandardNaturalWonderCountRange', 'Game', 'NATURAL_WONDER_COUNT', '0', 'GameOptions', '229'),
	('Ruleset', 'RULESET_EXPANSION_1', 'NaturalWonderCount', 'LOC_NATURAL_WONDER_COUNT_NAME', 'LOC_NATURAL_WONDER_COUNT_DESCRIPTION', 'Expansion1NaturalWonderCountRange', 'Game', 'NATURAL_WONDER_COUNT', '0', 'GameOptions', '229'),
	('Ruleset', 'RULESET_EXPANSION_2', 'NaturalWonderCount', 'LOC_NATURAL_WONDER_COUNT_NAME', 'LOC_NATURAL_WONDER_COUNT_DESCRIPTION', 'Expansion2NaturalWonderCountRange', 'Game', 'NATURAL_WONDER_COUNT', '0', 'GameOptions', '229');

-- Disable certain options if this is for the world builder
INSERT INTO ParameterDependencies (ParameterId, ConfigurationGroup, ConfigurationId, Operator, ConfigurationValue)
VALUES
    ('NaturalWonderCount', 'Game', 'WORLD_BUILDER', 'NotEquals', 1);

-- Define dynamic ranges for the Natural Wonders slider(s)
INSERT INTO DomainRangeQueries (QueryId)
VALUES
    ('StandardNaturalWonderCountRange'),
    ('Expansion1NaturalWonderCountRange'),
    ('Expansion2NaturalWonderCountRange');

/* ###########################################################################
Define value queries to set the lower and upper boundaries of the Natural Wonders slider(s)
Lower boundary : the value defined in MapSizes.MinNaturalWonders for the selected map size
Upper boundary : the lesser of:
    (1) the number of Natural Wonders available with the selected ruleset and any enabled additional content; or
    (2) the value defined in MapSizes.MaxNaturalWonders for the selected map size
########################################################################### */
INSERT INTO Queries (QueryId, SQL)
VALUES
    ('StandardNaturalWonderCountRange', 'SELECT ''StandardNaturalWonderCountRange'' AS Domain, ?1 AS MinimumValue, (SELECT CASE WHEN (SELECT Count(*) FROM NaturalWonders WHERE Domain = ''StandardNaturalWonders'') < ?2 THEN (SELECT Count(*) FROM NaturalWonders WHERE Domain = ''StandardNaturalWonders'') ELSE ?2 END) AS MaximumValue LIMIT 1'),
	('Expansion1NaturalWonderCountRange', 'SELECT ''Expansion1NaturalWonderCountRange'' AS Domain, ?1 AS MinimumValue, (SELECT CASE WHEN (SELECT Count(*) FROM NaturalWonders WHERE Domain = ''Expansion1NaturalWonders'') < ?2 THEN (SELECT Count(*) FROM NaturalWonders WHERE Domain = ''Expansion1NaturalWonders'') ELSE ?2 END) AS MaximumValue LIMIT 1'),
	('Expansion2NaturalWonderCountRange', 'SELECT ''Expansion2NaturalWonderCountRange'' AS Domain, ?1 AS MinimumValue, (SELECT CASE WHEN (SELECT Count(*) FROM NaturalWonders WHERE Domain = ''Expansion2NaturalWonders'') < ?2 THEN (SELECT Count(*) FROM NaturalWonders WHERE Domain = ''Expansion2NaturalWonders'') ELSE ?2 END) AS MaximumValue LIMIT 1');

/*
-- Parameters for the queries defined above *** BROKEN ***
INSERT INTO QueryParameters (QueryId, Index, ConfigurationGroup, ConfigurationId)
VALUES
    ('StandardNaturalWonderCountRange', '1', 'Map', 'MAP_MIN_NATURAL_WONDERS'),
    ('StandardNaturalWonderCountRange', '2', 'Map', 'MAP_MAX_NATURAL_WONDERS'),
    ('Expansion1NaturalWonderCountRange', '1', 'Map', 'MAP_MIN_NATURAL_WONDERS'),
    ('Expansion1NaturalWonderCountRange', '2', 'Map', 'MAP_MAX_NATURAL_WONDERS'),
    ('Expansion2NaturalWonderCountRange', '1', 'Map', 'MAP_MIN_NATURAL_WONDERS'),
    ('Expansion2NaturalWonderCountRange', '2', 'Map', 'MAP_MAX_NATURAL_WONDERS');
*/

-- Define minimum, maximum, and default values for the Natural Wonders slider(s) for each standard map size
UPDATE MapSizes
SET MinNaturalWonders = 0, MaxNaturalWonders = 4, DefaultNaturalWonders = 2
WHERE MapSizeType = 'MAPSIZE_DUEL' AND Domain = 'StandardMapSizes';

UPDATE MapSizes
SET MinNaturalWonders = 0, MaxNaturalWonders = 6, DefaultNaturalWonders = 3
WHERE MapSizeType = 'MAPSIZE_TINY' AND Domain = 'StandardMapSizes';

UPDATE MapSizes
SET MinNaturalWonders = 0, MaxNaturalWonders = 8, DefaultNaturalWonders = 4
WHERE MapSizeType = 'MAPSIZE_SMALL' AND Domain = 'StandardMapSizes';

UPDATE MapSizes
SET MinNaturalWonders = 0, MaxNaturalWonders = 10, DefaultNaturalWonders = 5
WHERE MapSizeType = 'MAPSIZE_STANDARD' AND Domain = 'StandardMapSizes';

UPDATE MapSizes
SET MinNaturalWonders = 0, MaxNaturalWonders = 12, DefaultNaturalWonders = 6
WHERE MapSizeType = 'MAPSIZE_LARGE' AND Domain = 'StandardMapSizes';

UPDATE MapSizes
SET MinNaturalWonders = 0, MaxNaturalWonders = 14, DefaultNaturalWonders = 7
WHERE MapSizeType = 'MAPSIZE_HUGE' AND Domain = 'StandardMapSizes';

/* ###########################################################################
    End ENWS Frontend configuration
########################################################################### */
