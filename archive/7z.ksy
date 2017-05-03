meta:
  id: sevenz
  title: "7zip file format"
  file-extension: 7z
  license: CC0-1.0
  endian: le
seq:
  - id: signature_header
    contents: [0x37, 0x7a, 0xBC, 0xAF, 0x27, 0x1C]
  - id: archive_version
    type: archive_version
  - id: start_header_crc
    type: u4
  - id: start_header
    type: start_header
types:
  uint64_v2:
    seq:
      - id: first_byte
        type: u1
      - id: extra_bytes
        type: u1
        repeat: expr
        repeat-expr: len - 1
    instances:
      len:
        value: >
          (first_byte & 0x80) == 0x00 ? 1 :
          (first_byte & 0xC0) == 0x80 ? 2 :
          (first_byte & 0xE0) == 0xC0 ? 3 :
          (first_byte & 0xF0) == 0xE0 ? 4 :
          (first_byte & 0xF8) == 0xF0 ? 5 :
          (first_byte & 0xFC) == 0xF8 ? 6 :
          (first_byte & 0xFE) == 0xFC ? 7 : 8
      first_byte_value:
        value: >
          len == 1 ? 0 :
          len == 2 ? ((first_byte & 0x7F) << 8) :
          len == 3 ? ((first_byte & 0x3F) << 16) :
          len == 4 ? ((first_byte & 0x0F) << 24) :
          len == 5 ? ((first_byte & 0x07) << 36) :
          len == 6 ? ((first_byte & 0x03) << 48) : 0
      value:
        value: first_byte_value + 0 #TODO add extra bytes with a new to_i method or similar
  uint64:
    seq:
      - id: b1
        type: u1
      - id: b2
        type: u1
        if: len >= 2
      - id: b3
        type: u1
        if: len >= 3
      - id: b4
        type: u1
        if: len >= 4
      - id: b5
        type: u1
        if: len >= 5
      - id: b6
        type: u1
        if: len >= 6
      - id: b7
        type: u1
        if: len >= 7
      - id: b8
        type: u1
        if: len >= 8
    instances:
      len:
        value: >
          (b1 & 0x80) == 0x00 ? 1 :
          (b1 & 0xC0) == 0x80 ? 2 :
          (b1 & 0xE0) == 0xC0 ? 3 :
          (b1 & 0xF0) == 0xE0 ? 4 :
          (b1 & 0xF8) == 0xF0 ? 5 :
          (b1 & 0xFC) == 0xF8 ? 6 :
          (b1 & 0xFE) == 0xFC ? 7 : 8
      value:
        value: >
          len == 1 ? b1 :
          len == 2 ? ((b1 & 0x7F) << 8) + b2 :
          len == 3 ? ((b1 & 0x3F) << 16) + (b2 | (b3 << 8)):
          len == 4 ? ((b1 & 0x0F) << 24) + (b2 | (b3 << 8) | (b4 << 16)):
          len == 5 ? ((b1 & 0x07) << 36) + (b2 | (b3 << 8) | (b4 << 16) | (b5 << 24)):
          len == 6 ? ((b1 & 0x03) << 48) + (b2 | (b3 << 8) | (b4 << 16) | (b5 << 24) | (b6 << 36)):
          len == 7 ? (b2 | (b3 << 8) | (b4 << 16) | (b5 << 24) | (b6 << 36) | (b7 << 48)) :
                     (b2 | (b3 << 8) | (b4 << 16) | (b5 << 24) | (b6 << 36) | (b7 << 48) | (b8 << 56))
  archive_version:
    seq:
      - id: major_version_number
        type: u1
      - id: minor_version_number
        type: u1
  start_header:
    seq:
      - id: next_header_offset
        type: u8
      - id: next_header_size
        type: u8
      - id: next_header_crc
        type: u4
    instances:
      next_header:
          pos: next_header_offset + 32
          type: segment
          size: next_header_size
  segment:
    seq:
      - id: segment_type
        type: u1
        enum: segment_types
      - id: segment_data
        type:
          switch-on: segment_type
          cases:
            segment_types::header: header
            segment_types::archive_properties: archive_properties
            segment_types::additional_streams_info: streams_info
            segment_types::main_streams_info: streams_info
            #segment_types::files_info: files_info
            #segment_types::pack_info: pack_info
            #segment_types::unpack_info: unpack_info
            #segment_types::folder: folder
            segment_types::encoded_header: encoded_header
    enums:
      segment_types:
        0x01: header
        0x02: archive_properties
        0x03: additional_streams_info
        0x04: main_streams_info
        0x05: files_info
        0x06: pack_info
        0x07: unpack_info
        0x0B: folder
        0x17: encoded_header
  header:
    seq:
      - id: archive_properties
        type: archive_properties
      - id: additional_streams_info
        type: additional_streams_info
      - id: main_streams_info
        type: main_streams_info
      - id: files_info
        type: files_info
      - id: end_byte
        contents: [0x00]
  archive_properties:
    seq:
      - id: properties
        type: property
        repeat: until
        repeat-until: _.property_type == 0
    types:
      property:
        seq:
          - id: property_type
            type: u1
          - id: data_size
            type: u8
          - id: data
            size: data_size
  additional_streams_info:
    seq:
      - id: segment_type
        contents: [0x03]
      - id: streams_info
        type: streams_info
  main_streams_info:
    seq:
      - id: segment_type
        contents: [0x04]
      - id: streams_info
        type: streams_info
  streams_info:
    seq:
      - id: pack_info
        type: pack_info
      #- id: coders_info
      #  type: coders_info
      #- id: sub_streams_info
      #  type: sub_streams_info
      #- id: end_byte
      #  contents: [0x00]
  files_info:
    seq:
      - id: data
        type: u1
  encoded_header:
    seq:
      - id: header
        type: streams_info
  pack_info:
    seq:
      - id: signature_byte
        contents: [0x06]
      - id: pack_position
        type: uint64
      - id: number_of_packed_streams
        type: uint64
#      - id: next_object_signature
#        type: u1
#      - id: next_object
#        type:
#          switch-on: next_object_signature
#          cases:
#            0x09: pack_sizes_object
#            0x0A: pack_stream_digests_object
#        repeat: until
#        repeat-until: next_object_signature == 0x00
#    types:
#      pack_sizes_object:
#        seq:
#          - id: pack_sizes
#            type: uint64_v2
#            repeat: expr
#            repeat-expr: _parent.number_of_packed_streams.value - 1
#      pack_stream_digests_object:
#        seq:
#          - id: all_are_defined
#            type: u1
#          - id: number_defined
#            type: u4
#          - id: crcs
#            type: u4
#            repeat: expr
#            repeat-expr: number_defined
  coders_info:
    seq:
      - id: data
        type: u1
  sub_streams_info:
    seq:
      - id: data
        type: u1
