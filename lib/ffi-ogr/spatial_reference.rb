module OGR
  class SpatialReference
    attr_accessor :ptr

    def initialize(ptr)
      @ptr = FFI::AutoPointer.new(ptr, self.class.method(:release))
      @ptr.autorelease = false
    end

    def self.release(ptr);end

    def free
      FFIOGR.OSRDestroySpatialReference(@ptr)
    end

    def self.create
      OGR::Tools.cast_spatial_reference(FFIOGR.OSRNewSpatialReference(nil))
    end

    def self.from_wkt(wkt)
      sr = OGR::Tools.cast_spatial_reference(FFIOGR.OSRNewSpatialReference(nil))
      sr.import_wkt(wkt)
      sr
    end

    def self.from_proj4(proj4)
      sr = OGR::Tools.cast_spatial_reference(FFIOGR.OSRNewSpatialReference(nil))
      sr.import_proj4(proj4)
      sr
    end

    def self.from_epsg(epsg_code)
      sr = OGR::Tools.cast_spatial_reference(FFIOGR.OSRNewSpatialReference(nil))
      sr.import_epsg(epsg_code)
      sr
    end

    def import_wkt(wkt)
      wkt_ptr = FFI::MemoryPointer.from_string wkt
      wkt_ptr_ptr = FFI::MemoryPointer.new :pointer
      wkt_ptr_ptr.put_pointer 0, wkt_ptr
      FFIOGR.OSRImportFromWkt(@ptr, wkt_ptr_ptr)
    end

    def import_proj4(proj4)
      FFIOGR.OSRImportFromProj4(@ptr, proj4)
    end

    def import_epsg(epsg_code)
      FFIOGR.OSRImportFromEPSG(@ptr, epsg_code)
    end

    def to_wkt(pretty=false)
      ptr = FFI::MemoryPointer.new :pointer

      unless pretty
        FFIOGR.OSRExportToWkt(@ptr, ptr)
      else
        FFIOGR.OSRExportToPrettyWkt(@ptr, ptr, 4)
      end
      str_ptr = ptr.read_pointer

      return str_ptr.null? ? nil : str_ptr.read_string
    end

    def to_proj4
      ptr = FFI::MemoryPointer.new :pointer
      FFIOGR.OSRExportToProj4(@ptr, ptr)
      str_ptr = ptr.read_pointer
      return str_ptr.null? ? nil: str_ptr.read_string
    end

    def ==(other)
      self.to_wkt == other.to_wkt
    end

    def find_transformation(out_sr)
      CoordinateTransformation.find_transformation self, out_sr
    end
  end
end
