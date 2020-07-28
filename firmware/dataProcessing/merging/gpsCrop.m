function TT = gpsCrop(TT,latitude,longitude,latRange,longRange)
    
    TT= TT(TT.latitudeCoordinate_GPSGPGGA2>latitude-abs(latRange),:);
    TT= TT(TT.latitudeCoordinate_GPSGPGGA2<latitude+abs(latRange),:);
    TT= TT(TT.longitudeCoordinate_GPSGPGGA2>longitude-abs(longRange),:);
    TT= TT(TT.longitudeCoordinate_GPSGPGGA2<longitude+abs(longRange),:);
end

