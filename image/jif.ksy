meta:
  id: jif_non_hierarchical
  file-extension: jif
  endian: be
  #compliance suite: https://www.itu.int/net/itu-t/sigdb/speimage/ImageForm-s.aspx?val=1010083
seq:
  - id: start_of_image_marker
    type: marker
    doc: must be the start of image (SOI) marker code
  - id: frame
    type: frame
#  - id: end_of_image_marker
#    contents: [0xFF, 0xD9]
types:
  frame:
    seq:
      - id: table_or_misc_segments
        type: table_or_misc_segment
        repeat: until
        repeat-until: >-
          _.next_marker.code != marker_codes::define_quantization_tables and
          _.next_marker.code != marker_codes::huffman_table_specification and
          _.next_marker.code != marker_codes::arithmetic_coding_conditioning_specification and
          _.next_marker.code != marker_codes::define_restart_interval and
          _.next_marker.code != marker_codes::comment and
          _.next_marker.code != marker_codes::application_segment_0 and
          _.next_marker.code != marker_codes::application_segment_1 and
          _.next_marker.code != marker_codes::application_segment_2 and
          _.next_marker.code != marker_codes::application_segment_3 and
          _.next_marker.code != marker_codes::application_segment_4 and
          _.next_marker.code != marker_codes::application_segment_5 and
          _.next_marker.code != marker_codes::application_segment_6 and
          _.next_marker.code != marker_codes::application_segment_7 and
          _.next_marker.code != marker_codes::application_segment_8 and
          _.next_marker.code != marker_codes::application_segment_9 and
          _.next_marker.code != marker_codes::application_segment_10 and
          _.next_marker.code != marker_codes::application_segment_11 and
          _.next_marker.code != marker_codes::application_segment_12 and
          _.next_marker.code != marker_codes::application_segment_13 and
          _.next_marker.code != marker_codes::application_segment_14 and
          _.next_marker.code != marker_codes::application_segment_15
      - id: header
        type: frame_header
      - id: first_scan
        type: scan
        if: header.next_marker.code != marker_codes::start_of_scan
      - id: first_scan
        type: scan_without_table_or_misc_segments
        if: header.next_marker.code == marker_codes::start_of_scan
      - id: define_number_of_lines_segment
        type: define_number_of_lines_segment
        if: first_scan.next_marker.code == marker_codes::define_number_of_lines
      - id: additional_scans
        type:
          switch-on: _.next_marker.code
          cases:
            marker_codes::start_of_scan: scan_without_table_or_misc_segments
            _: scan
        repeat: until
        repeat-until: >-
          _.next_marker.code != marker_codes::start_of_scan and
          _.next_marker.code != marker_codes::define_quantization_tables and
          _.next_marker.code != marker_codes::huffman_table_specification and
          _.next_marker.code != marker_codes::arithmetic_coding_conditioning_specification and
          _.next_marker.code != marker_codes::define_restart_interval and
          _.next_marker.code != marker_codes::comment and
          _.next_marker.code != marker_codes::application_segment_0 and
          _.next_marker.code != marker_codes::application_segment_1 and
          _.next_marker.code != marker_codes::application_segment_2 and
          _.next_marker.code != marker_codes::application_segment_3 and
          _.next_marker.code != marker_codes::application_segment_4 and
          _.next_marker.code != marker_codes::application_segment_5 and
          _.next_marker.code != marker_codes::application_segment_6 and
          _.next_marker.code != marker_codes::application_segment_7 and
          _.next_marker.code != marker_codes::application_segment_8 and
          _.next_marker.code != marker_codes::application_segment_9 and
          _.next_marker.code != marker_codes::application_segment_10 and
          _.next_marker.code != marker_codes::application_segment_11 and
          _.next_marker.code != marker_codes::application_segment_12 and
          _.next_marker.code != marker_codes::application_segment_13 and
          _.next_marker.code != marker_codes::application_segment_14 and
          _.next_marker.code != marker_codes::application_segment_15
#        type: scan
#        repeat: until
#        repeat-until: _.next_marker.code != marker_codes::start_of_scan
#        if: >-
#          first_scan.next_marker.code == marker_codes::start_of_scan or
#          (first_scan.next_marker.code == marker_codes::define_number_of_lines and
#           define_number_of_lines_segment.next_marker.code == marker_codes::start_of_scan)
    types:
      table_or_misc_segment:
        seq:
          - id: marker
            type: marker
          - id: length
            type: u2
          - id: data
            size: length - 2
            type:
              switch-on: marker.code
              cases:
                marker_codes::define_quantization_tables: define_quantization_tables_segment
                marker_codes::huffman_table_specification: huffman_table_specification_segment
                marker_codes::arithmetic_coding_conditioning_specification: arithmetic_coding_conditioning_specification_segment
                marker_codes::define_restart_interval: define_restart_interval_segment
        instances:
          next_marker:
            pos: _io.pos
            type: marker
        types:
          define_quantization_tables_segment:
            seq:
              - id: quantization_tables
                type: quantization_table
                repeat: eos
            types:
              quantization_table:
                seq:
                  - id: element_precision
                    type: b4
                  - id: destination_identifier
                    type: b4
                  - id: elements
                    type:
                      switch-on: element_precision
                      cases:
                        0: element_8_bit_precision
                        1: element_16_bit_precision
                    repeat: expr
                    repeat-expr: 64
                types:
                  element_8_bit_precision:
                    seq:
                      - id: value
                        type: u1
                  element_16_bit_precision:
                    seq:
                      - id: value
                        type: u2
          huffman_table_specification_segment:
            seq:
              - id: quantization_tables
                type: quantization_table
                repeat: eos
                doc: the number of quantization tables shall equal the number of quantization tables specified in define_quantization_tables_segment (DQT segment)
            types:
              quantization_table:
                seq:
                  - id: table_class
                    type: b4
                    doc: value of 0 for DC table or lossless table, value of 1 for AC table
                  - id: huffman_table_destination_identifier
                    type: b4
                  - id: number_of_huffman_codes_of_length_1
                    type: u1
                  - id: number_of_huffman_codes_of_length_2
                    type: u1
                  - id: number_of_huffman_codes_of_length_3
                    type: u1
                  - id: number_of_huffman_codes_of_length_4
                    type: u1
                  - id: number_of_huffman_codes_of_length_5
                    type: u1
                  - id: number_of_huffman_codes_of_length_6
                    type: u1
                  - id: number_of_huffman_codes_of_length_7
                    type: u1
                  - id: number_of_huffman_codes_of_length_8
                    type: u1
                  - id: number_of_huffman_codes_of_length_9
                    type: u1
                  - id: number_of_huffman_codes_of_length_10
                    type: u1
                  - id: number_of_huffman_codes_of_length_11
                    type: u1
                  - id: number_of_huffman_codes_of_length_12
                    type: u1
                  - id: number_of_huffman_codes_of_length_13
                    type: u1
                  - id: number_of_huffman_codes_of_length_14
                    type: u1
                  - id: number_of_huffman_codes_of_length_15
                    type: u1
                  - id: number_of_huffman_codes_of_length_16
                    type: u1
                  - id: values_associated_with_huffman_code_of_length_1
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_1
                  - id: values_associated_with_huffman_code_of_length_2
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_2
                  - id: values_associated_with_huffman_code_of_length_3
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_3
                  - id: values_associated_with_huffman_code_of_length_4
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_4
                  - id: values_associated_with_huffman_code_of_length_5
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_5
                  - id: values_associated_with_huffman_code_of_length_6
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_6
                  - id: values_associated_with_huffman_code_of_length_7
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_7
                  - id: values_associated_with_huffman_code_of_length_8
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_8
                  - id: values_associated_with_huffman_code_of_length_9
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_9
                  - id: values_associated_with_huffman_code_of_length_10
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_10
                  - id: values_associated_with_huffman_code_of_length_11
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_11
                  - id: values_associated_with_huffman_code_of_length_12
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_12
                  - id: values_associated_with_huffman_code_of_length_13
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_13
                  - id: values_associated_with_huffman_code_of_length_14
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_14
                  - id: values_associated_with_huffman_code_of_length_15
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_15
                  - id: values_associated_with_huffman_code_of_length_16
                    type: u1
                    repeat: expr
                    repeat-expr: number_of_huffman_codes_of_length_16
          arithmetic_coding_conditioning_specification_segment:
            seq:
              - id: arithmetic_conditioning_tables
                type: arithmetic_conditioning_table
                repeat: eos
            types:
              arithmetic_conditioning_table:
                seq:
                  - id: table_class
                    type: b4
                    doc: value of 0 for DC table or lossless table, value of 1 for AC table
                  - id: arithmetic_coding_conditioning_table_destination_identifier
                    type: b4
                  - id: conditioning_table_value_dc_lossless
                    type: u1
                    if: table_class == 0b0000
                  - id: conditioning_table_value_ac_upper_conditioning_bound
                    type: b4
                    if: table_class == 0b0001
                  - id: conditioning_table_value_ac_lower_conditioning_bound
                    type: b4
                    if: table_class == 0b0001
                instances:
                  conditioning_table_value_ac:
                    value: >-
                      (conditioning_table_value_ac_upper_conditioning_bound << 4) |
                      conditioning_table_value_ac_lower_conditioning_bound
                    if: table_class == 0b0001
          define_restart_interval_segment:
            seq:
              - id: number_of_mcu_in_restart_interval
                type: u2
      frame_header:
        seq:
          - id: start_of_frame_marker
            type: marker
            doc: must be one of the start of frame (SOFx) marker codes
          - id: length
            type: u2
          - id: data
            type: frame_header_data
            size: length - 2
        types:
          frame_header_data:
            seq:
              - id: sample_precision
                type: u1
              - id: number_of_lines
                type: u2
              - id: number_of_samples_per_line
                type: u2
              - id: number_of_image_components_in_frame
                type: u1
              - id: frame_component_specification_parameters
                type: frame_component_specification_parameter_group
                repeat: expr
                repeat-expr: number_of_image_components_in_frame
            types:
              frame_component_specification_parameter_group:
                seq:
                  - id: component_identifier
                    type: u1
                  - id: horizontal_sampling_factor
                    type: b4
                  - id: vertical_sampling_factor
                    type: b4
                  - id: quantization_table_destination_selector
                    type: u1
        instances:
          next_marker:
            pos: _io.pos
            type: marker
      scan:
        seq:
          - id: table_or_misc_segments
            type: table_or_misc_segment
            repeat: until
            repeat-until: >-
              _.next_marker.code != marker_codes::define_quantization_tables and
              _.next_marker.code != marker_codes::huffman_table_specification and
              _.next_marker.code != marker_codes::arithmetic_coding_conditioning_specification and
              _.next_marker.code != marker_codes::define_restart_interval and
              _.next_marker.code != marker_codes::comment and
              _.next_marker.code != marker_codes::application_segment_0 and
              _.next_marker.code != marker_codes::application_segment_1 and
              _.next_marker.code != marker_codes::application_segment_2 and
              _.next_marker.code != marker_codes::application_segment_3 and
              _.next_marker.code != marker_codes::application_segment_4 and
              _.next_marker.code != marker_codes::application_segment_5 and
              _.next_marker.code != marker_codes::application_segment_6 and
              _.next_marker.code != marker_codes::application_segment_7 and
              _.next_marker.code != marker_codes::application_segment_8 and
              _.next_marker.code != marker_codes::application_segment_9 and
              _.next_marker.code != marker_codes::application_segment_10 and
              _.next_marker.code != marker_codes::application_segment_11 and
              _.next_marker.code != marker_codes::application_segment_12 and
              _.next_marker.code != marker_codes::application_segment_13 and
              _.next_marker.code != marker_codes::application_segment_14 and
              _.next_marker.code != marker_codes::application_segment_15
          - id: header
            type: scan_header
          - id: entropy_coded_segments_including_restart_markers
            type: entropy_coded_segment_including_restart_marker
            repeat: until
            repeat-until: _.next_marker_high == 0xFF
        instances:
          next_marker:
            pos: _io.pos
            type: marker
      scan_without_table_or_misc_segments:
        seq:
          - id: header
            type: scan_header
          - id: entropy_coded_segments_including_restart_markers
            type: entropy_coded_segment_including_restart_marker
            repeat: until
            repeat-until: _.next_marker_high == 0xFF
        instances:
          next_marker:
            pos: _io.pos
            type: marker
      scan_header:
        seq:
          - id: start_of_scan_marker
            type: marker
            doc: must be the start of scan (SOS) marker code
          - id: length
            type: u2
          - id: data
            type: scan_header_data
            size: length - 2
        types:
          scan_header_data:
            seq:
              - id: number_of_image_components_in_scan
                type: u1
              - id: component_specification_parameters
                type: component_specification_parameters_per_component
                repeat: expr
                repeat-expr: number_of_image_components_in_scan
              - id: start_of_spectral_or_predictor_selection
                type: u1
              - id: end_of_spectral_selection
                type: u1
              - id: successive_approximation_bit_position_high
                type: b4
              - id: successive_approximation_bit_position_low
                type: b4
            types:
              component_specification_parameters_per_component:
                seq:
                  - id: scan_component_selector
                    type: u1
                  - id: dc_entropy_coding_table_destination_selector
                    type: b4
                  - id: ac_entropy_coding_table_destination_selector
                    type: b4
      entropy_coded_segment_including_restart_marker:
        seq:
          - id: entropy_coded_segment
            type: compressed_data_block
            repeat: until
            repeat-until: _.next_bytes != 0xFF00
          - id: restart_marker
            type: marker
            if: >-
              entropy_coded_segment.last.next_marker.code == marker_codes::restart_interval_termination_0 or
              entropy_coded_segment.last.next_marker.code == marker_codes::restart_interval_termination_1 or
              entropy_coded_segment.last.next_marker.code == marker_codes::restart_interval_termination_2 or
              entropy_coded_segment.last.next_marker.code == marker_codes::restart_interval_termination_3 or
              entropy_coded_segment.last.next_marker.code == marker_codes::restart_interval_termination_4 or
              entropy_coded_segment.last.next_marker.code == marker_codes::restart_interval_termination_5 or
              entropy_coded_segment.last.next_marker.code == marker_codes::restart_interval_termination_6 or
              entropy_coded_segment.last.next_marker.code == marker_codes::restart_interval_termination_7
        instances:
          next_marker_high:
            pos: _io.pos
            type: u1
        types:
          compressed_data_block:
            seq:
              - id: start_bytes
                type: start_bytes
              - id: escaped_ff_value
                contents: [0xFF, 0x00]
                if: start_bytes.raw_bytes == 0xFF00
              - id: compressed_data
                terminator: 0xFF
                consume: false
            instances:
              next_bytes:
                pos: _io.pos
                type: u2
              next_marker:
                pos: _io.pos
                type: marker
                if: next_bytes != 0xFF00 and next_bytes & 0xFF00 == 0xFF00
            types:
              start_bytes:
                instances:
                  raw_bytes:
                    pos: _io.pos
                    type: u2
  define_number_of_lines_segment:
    seq:
      - id: number_of_lines_in_frame
        type: u2
    instances:
      next_marker:
        pos: _io.pos
        type: marker
  marker:
    seq:
      - id: ff_bytes
        type: ff_byte
        repeat: until
        repeat-until: _.next_byte != 0xFF
      - id: code
        type: u1
        enum: marker_codes
    types:
      ff_byte:
        seq:
          - id: ff_byte
            contents: [0xFF]
        instances:
          next_byte:
            pos: _io.pos
            type: u1
enums:
  marker_codes:
    0xC0: non_differential_huffman_coding_baseline_dct_frame #SOF0
    0xC1: non_differential_huffman_coding_extended_sequential_dct_frame #SOF1
    0xC2: non_differential_huffman_coding_progressive_dct_frame #SOF2
    0xC3: non_differential_huffman_coding_lossless_sequential_frame #SOF3
    0xC5: differential_huffman_coding_sequential_dct_frame #SOF5
    0xC6: differential_huffman_coding_progressive_dct_frame #SOF6
    0xC7: differential_huffman_coding_lossless_sequential_frame #SOF7
    0xC8: non_differential_arithmetic_coding_reserved_for_jpeg_extensions_frame #JPG
    0xC9: non_differential_arithmetic_coding_extended_sequential_dct_frame #SOF9
    0xCA: non_differential_arithmetic_coding_progressive_dct_frame #SOF10
    0xCB: non_differential_arithmetic_coding_lossless_sequential_frame #SOF11
    0xCD: differential_arithmetic_coding_sequential_dct_frame #SOF13
    0xCE: differential_arithmetic_coding_progressive_dct_frame #SOF13
    0xCF: differential_arithmetic_coding_lossless_sequential_frame #SOF13
    0xC4: huffman_table_specification #DHT
    0xCC: arithmetic_coding_conditioning_specification #DAC
    0xD0: restart_interval_termination_0 #RST0
    0xD1: restart_interval_termination_1 #RST1
    0xD2: restart_interval_termination_2 #RST2
    0xD3: restart_interval_termination_3 #RST3
    0xD4: restart_interval_termination_4 #RST4
    0xD5: restart_interval_termination_5 #RST5
    0xD6: restart_interval_termination_6 #RST6
    0xD7: restart_interval_termination_7 #RST7
    0xD8: start_of_image #SOI
    0xD9: end_of_image #EOI
    0xDA: start_of_scan #SOS
    0xDB: define_quantization_tables #DQT
    0xDC: define_number_of_lines #DNL
    0xDD: define_restart_interval #DRI
    0xDE: define_hierarchical_progression #DHP
    0xDF: expand_reference_components #EXP
    0xE0: application_segment_0 #APP0
    0xE1: application_segment_1 #APP1
    0xE2: application_segment_2 #APP2
    0xE3: application_segment_3 #APP3
    0xE4: application_segment_4 #APP4
    0xE5: application_segment_5 #APP5
    0xE6: application_segment_6 #APP6
    0xE7: application_segment_7 #APP7
    0xE8: application_segment_8 #APP8
    0xE9: application_segment_9 #APP9
    0xEA: application_segment_10 #APP10
    0xEB: application_segment_11 #APP11
    0xEC: application_segment_12 #APP12
    0xED: application_segment_13 #APP13
    0xEE: application_segment_14 #APP14
    0xEF: application_segment_15 #APP15
    0xF0: jpeg_extension_0 #JPG0
    0xF1: jpeg_extension_1 #JPG1
    0xF2: jpeg_extension_2 #JPG2
    0xF3: jpeg_extension_3 #JPG3
    0xF4: jpeg_extension_4 #JPG4
    0xF5: jpeg_extension_5 #JPG5
    0xF6: jpeg_extension_6 #JPG6
    0xF7: jpeg_extension_7 #JPG7
    0xF8: jpeg_extension_8 #JPG8
    0xF9: jpeg_extension_9 #JPG9
    0xFA: jpeg_extension_10 #JPG10
    0xFB: jpeg_extension_11 #JPG11
    0xFC: jpeg_extension_12 #JPG12
    0xFD: jpeg_extension_13 #JPG13
    0xFE: comment #COM
    0x01: for_temporary_use_in_arithmetic_coding #TEM
    0x00: escaped_ff_in_compressed_data