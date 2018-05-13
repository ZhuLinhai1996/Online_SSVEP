%    载入数据文件
function raw = LoadData(file)
    fid = fopen(file);
    line_count = LineNumber(fid);
    raw = cell(line_count,1);
    frewind(fid);
    line = 1;
    while feof(fid) == 0
        raw{line,1} = fgetl(fid);
        line = line+1;
    end
end