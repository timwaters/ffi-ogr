module OGR
  class LineString < Geometry
    def self.create(points)
      ls = OGR::Tools.cast_geometry(FFIOGR.OGR_G_CreateGeometry(:line_string))

      points.each do |point|
        ls.add_point(point)
      end

      ls
    end
  end
end
