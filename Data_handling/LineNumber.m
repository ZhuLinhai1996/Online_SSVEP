%    获得数据行数
function count = LineNumber(fid)
    count = 0;
        while feof(fid) == 0
            tline = fgetl(fid);
            count = count+1;
        end
end
