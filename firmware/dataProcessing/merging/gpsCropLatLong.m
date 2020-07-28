function TT = gpsCrop(TT,latitude,longitude,latRange,longRange)
    
    TT= TT(TT.latitude>latitude-abs(latRange),:);
    TT= TT(TT.latitude<latitude+abs(latRange),:);
    TT= TT(TT.longitude>longitude-abs(longRange),:);
    TT= TT(TT.longitude<longitude+abs(longRange),:);
end

