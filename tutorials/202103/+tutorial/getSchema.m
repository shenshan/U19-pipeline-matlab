function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'tutorial', 'shans_tutorial');
end
obj = schemaObject;
end
