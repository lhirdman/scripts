begin
dbms_stats.gather_schema_stats(
ownname => 'TIFIC',
options => 'GATHER',
estimate_percent => dbms_stats.auto_sample_size,
method_opt => 'FOR ALL COLUMNS SIZE AUTO',
degree => dbms_stats.default_degree,
cascade => false
);
end;
/
