module OGR
  class MultiPolygon < Geometry
    def self.create(polygons)
      multi_polygon = OGR::Tools.cast_geometry(FFIOGR.OGR_G_CreateGeometry(:multi_polygon))

      polygons.each do |polygon|
        poly = OGR::Polygon.create(polygon)
        multi_polygon.add_geometry(poly)
      end

      multi_polygon
    end
  end
end
