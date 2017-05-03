meta:
  id: nitf_21
  encoding: ASCII
  endian: be
seq:
  - id: header
    type: file_header
  - id: image_segments
    type: image_segment
#    repeat: expr
#    repeat-expr: header.number_of_image_segments
#    if: header.number_of_image_segments != 0
#  - id: graphic_segments
#    type: graphic_segment
#    repeat: expr
#    repeat-expr: header.number_of_graphic_segments
#    if: header.number_of_graphic_segments != 0
#  - id: text_segments
#    type: text_segment
#    repeat: expr
#    repeat-expr: header.number_of_text_segments
#    if: header.number_of_text_segments != 0
#  - id: data_extension_segments
#    type: data_extension_segment
#    repeat: expr
#    repeat-expr: header.number_of_data_extension_segments
#    if: header.number_of_data_extension_segments != 0
#  - id: reserved_extension_segments
#    type: reserved_extension_segment
#    repeat: expr
#    repeat-expr: header.number_of_reserved_extension_segments
#    if: header.number_of_reserved_extension_segments != 0
types:
  file_header:
    seq:
      - id: file_profile_name
        contents: [0x4E, 0x49, 0x54, 0x46] #NITF
      - id: file_version
        contents: [0x30, 0x32, 0x2E, 0x31, 0x30] #02.10
      - id: complexity_level_raw
        type: str
        size: 2
        #encoding: BCS-N-Pos-Int
      - id: standard_type
        contents: [0x42, 0x46, 0x30, 0x31] #BF01
      - id: originating_station_id
        type: str
        size: 10
      - id: file_date_and_time
        type: date_and_time
      - id: file_title
        type: str
        size: 80
      - id: file_security_fields
        type: security_fields
      - id: file_copy_number_raw
        type: str
        size: 5
        #encoding: BCS-N-Pos-Int
      - id: file_number_of_copies_raw
        type: str
        size: 5
        #encoding: BCS-N-Pos-Int
      - id: encryption
        contents: [0x30]
      - id: file_background_color
        type: rgb_color
      - id: originators_name
        type: str
        size: 24
        #encoding: ECS-A
      - id: originators_phone_number
        type: str
        size: 18
        #encoding: ECS-A
      - id: file_length_raw
        type: str
        size: 12
        #encoding: BCS-N-Pos-Int
      - id: file_header_length_raw
        type: str
        size: 6
        #encoding: BCS-N-Pos-Int
      - id: number_of_image_segments_raw
        type: str
        size: 3
        #encoding: BCS-N-Pos-Int
      - id: image_segment_definitions
        type: image_segment_definition
        repeat: expr
        repeat-expr: number_of_image_segments
      - id: number_of_graphic_segments_raw
        type: str
        size: 3
        #encoding: BCS-N-Pos-Int
      - id: graphic_segment_definitions
        type: graphic_segment_definition
        repeat: expr
        repeat-expr: number_of_graphic_segments
      - id: reserved_for_future_use
        contents: [0x30, 0x30, 0x30]
      - id: number_of_text_segments_raw
        type: str
        size: 3
        #encoding: BCS-N-Pos-Int
      - id: text_segment_definitions
        type: text_segment_definition
        repeat: expr
        repeat-expr: number_of_text_segments
      - id: number_of_data_extension_segments_raw
        type: str
        size: 3
        #encoding: BCS-N-Pos-Int
      - id: data_extension_segment_definitions
        type: data_extension_segment_definition
        repeat: expr
        repeat-expr: number_of_data_extension_segments
      - id: number_of_reserved_extension_segments_raw
        type: str
        size: 3
        #encoding: BCS-N-Pos-Int
      - id: reserved_extension_segment_definitions
        type: reserved_extension_segment_definition
        repeat: expr
        repeat-expr: number_of_reserved_extension_segments
      - id: user_defined_header_data_length_raw
        type: str
        size: 5
        #encoding: BCS-N-Pos-Int
      - id: user_defined_header_overflow_raw
        type: str
        size: 3
        #encoding: BCS-N-Pos-Int
        if: user_defined_header_data_length != 0
      - id: user_defined_header_data
        size: user_defined_header_data_length - 3
        if: user_defined_header_data_length != 0
      - id: extended_header_data_length_raw
        type: str
        size: 5
        #encoding: BCS-N-Pos-Int
      - id: extended_header_data_overflow_raw
        type: str
        size: 3
        #encoding: BCS-N-Pos-Int
        if: extended_header_data_length != 0
      - id: extended_header_data
        size: extended_header_data_length - 3
        if: extended_header_data_length != 0
    instances:
      complexity_level:
        value: complexity_level_raw.to_i
      file_copy_number:
        value: file_copy_number_raw.to_i
      file_number_of_copies:
        value: file_number_of_copies_raw.to_i
      file_length:
        value: file_length_raw.to_i
      file_header_length:
        value: file_header_length_raw.to_i
      number_of_image_segments:
        value: number_of_image_segments_raw.to_i
      number_of_graphic_segments:
        value: number_of_graphic_segments_raw.to_i
      number_of_text_segments:
        value: number_of_text_segments_raw.to_i
      number_of_data_extension_segments:
        value: number_of_data_extension_segments_raw.to_i
      number_of_reserved_extension_segments:
        value: number_of_reserved_extension_segments_raw.to_i
      user_defined_header_data_length:
        value: user_defined_header_data_length_raw.to_i
      user_defined_header_overflow:
        value: user_defined_header_overflow_raw.to_i
      extended_header_data_length:
        value: extended_header_data_length_raw.to_i
      extended_header_data_overflow:
        value: extended_header_data_overflow_raw.to_i
    types:
      image_segment_definition:
        seq:
          - id: image_subheader_length_raw
            type: str
            size: 6
            #encoding: BCS-N-Pos-Int
          - id: image_segment_length_raw
            type: str
            size: 10
            #encoding: BCS-N-Pos-Int
        instances:
          image_subheader_length:
            value: image_subheader_length_raw.to_i
          image_segment_length:
            value: image_segment_length_raw.to_i
      graphic_segment_definition:
        seq:
          - id: graphic_subheader_length_raw
            type: str
            size: 4
            #encoding: BCS-N-Pos-Int
          - id: graphic_segment_length_raw
            type: str
            size: 6
            #encoding: BCS-N-Pos-Int
        instances:
          graphic_subheader_length:
            value: graphic_subheader_length_raw.to_i
          graphic_segment_length:
            value: graphic_segment_length_raw.to_i
      text_segment_definition:
        seq:
          - id: text_subheader_length_raw
            type: str
            size: 4
            #encoding: BCS-N-Pos-Int
          - id: text_segment_length_raw
            type: str
            size: 5
            #encoding: BCS-N-Pos-Int
        instances:
          text_subheader_length:
            value: text_subheader_length_raw.to_i
          text_segment_length:
            value: text_segment_length_raw.to_i
      data_extension_segment_definition:
        seq:
          - id: data_extension_subheader_length_raw
            type: str
            size: 4
            #encoding: BCS-N-Pos-Int
          - id: data_extension_segment_length_raw
            type: str
            size: 9
            #encoding: BCS-N-Pos-Int
        instances:
          data_extension_subheader_length:
            value: data_extension_subheader_length_raw.to_i
          data_extension_segment_length:
            value: data_extension_segment_length_raw.to_i
      reserved_extension_segment_definition:
        seq:
          - id: reserved_extension_subheader_length_raw
            type: str
            size: 4
            #encoding: BCS-N-Pos-Int
          - id: reserved_extension_segment_length_raw
            type: str
            size: 7
            #encoding: BCS-N-Pos-Int
        instances:
          reserved_extension_subheader_length:
            value: reserved_extension_subheader_length_raw.to_i
          reserved_extension_segment_length:
            value: reserved_extension_segment_length_raw.to_i
  image_segment:
    seq:
      - id: header
        type: image_segment_header
      - id: data_mask_table
        type: image_data_mask_table
        if: >-
          header.image_compression_method == image_compression_methods::uncompressed_with_block_and_or_pad_pixel_mask or
          header.image_compression_method == image_compression_methods::itu_t_t_4_amd_2 or
          header.image_compression_method == image_compression_methods::mil_std_188_198a or
          header.image_compression_method == image_compression_methods::mil_std_188_199 or
          header.image_compression_method == image_compression_methods::nga_n0106_07 or
          header.image_compression_method == image_compression_methods::reserved_correlated_multicomponent_compression_m or
          header.image_compression_method == image_compression_methods::reserved_sar_compression_m or
          header.image_compression_method == image_compression_methods::iso_iec_15444_1_2000_amd_1_amd_2_m
      - id: data
        size: 0
    types:
      image_segment_header:
        seq:
          - id: file_part_type
            contents: [0x49, 0x4D]
          - id: image_identifier_1
            type: str
            size: 10
            #encoding: BCS-A
          - id: image_date_and_time
            type: date_and_time
          - id: target_identifier
            type: target_identifier
          - id: image_identifier_2
            type: str
            size: 80
            #encoding: ECS-A
          - id: image_security_fields
            type: security_fields
          - id: encryption
            contents: [0x30]
          - id: image_source
            type: str
            size: 42
            #encoding: ECS-A
          - id: number_of_significant_rows_in_image_raw
            type: str
            size: 8
            #encoding: BCS-N-Pos-Int
          - id: number_of_significant_columns_in_image_raw
            type: str
            size: 8
            #encoding: BCS-N-Pos-Int
          - id: pixel_value_type
            type: str
            size: 3
            #encoding: BCS-A
            doc: value must be either INT, B, SI, R or C
          - id: image_representation
            type: str
            size: 8
            #encoding: BCS-A
            doc: value must be either MONO, RGB, RGB/LUT, MULTI, NODISPLY, NVECTOR, POLAR, VPH or YCbCr601
          - id: image_cateogry
            type: str
            size: 8
            doc: value must be either VIS, SL, TI, FL, RD, EO, OP, HR, HS, CP, BP, SAR, SARIQ, IR, MAP, MS, FP, MRI, XRAY, CAT, VD, PAT, LEG, DTEM, MATR, LOCG, BARO, CURRENT, DEPTH or WIND
          - id: actual_bits_per_pixel_per_band_raw
            type: str
            size: 2
            #encoding: BCS-N-Pos-Int
          - id: pixel_justification
            type: u1
            enum: pixel_justifications
          - id: image_coordinate_representation
            type: u1
            enum: image_coordinate_representations
          - id: image_geographic_location
            type: str
            size: 60
            #encoding: BCS-A
            if: image_coordinate_representation != image_coordinate_representations::not_applicable
          - id: number_of_image_comments_raw
            type: str
            size: 1
            #encoding: BCS-N-Pos-Int
          - id: image_comments
            type: str
            size: 80
            #encoding: ECS-A
            repeat: expr
            repeat-expr: number_of_image_comments
          - id: image_compression_method
            type: u2
            enum: image_compression_methods
          - id: compression_rate_code
            type: str
            size: 4
            #encoding: BCS-A
          - id: number_of_bands_raw
            type: str
            size: 1
          - id: number_of_multispectral_bands_raw
            type: str
            size: 5
            if: not (number_of_bands >= 1 and number_of_bands <= 9)
          - id: bands
            type: band
            repeat: expr
            repeat-expr: number_of_bands
            if: number_of_bands >= 1 and number_of_bands <= 9
          - id: bands
            type: band
            repeat: expr
            repeat-expr: number_of_multispectral_bands
            if: not (number_of_bands >= 1 and number_of_bands <= 9)
          - id: image_sync_code
            contents: [0x30]
          - id: image_mode
            type: u1
            enum: image_modes
          - id: number_of_blocks_per_row_raw
            type: str
            size: 4
            #encoding: BCS-N-Pos-Int
          - id: number_of_blocks_per_column_raw
            type: str
            size: 4
            #encoding: BCS-N-Pos-Int
          - id: number_of_pixels_per_block_horizontal_raw
            type: str
            size: 4
            #encoding: BCS-N-Pos-Int
          - id: number_of_pixels_per_block_vertical_raw
            type: str
            size: 4
            #encoding: BCS-N-Pos-Int
          - id: number_of_bits_per_pixel_per_band_raw
            type: str
            size: 2
            #encoding: BCS-N-Pos-Int
          - id: image_display_level_raw
            type: str
            size: 3
            #encoding: BCS-N-Pos-Int
          - id: attachment_level_raw
            type: str
            size: 3
            #encoding: BCS-N-Pos-Int
          - id: image_location
            type: image_location
          - id: image_magnification
            type: str
            size: 4
            #encoding: BCS-A
          - id: user_defined_image_data_length_raw
            type: str
            size: 5
            #encoding: BCS-N-Pos-Int
          - id: user_defined_overflow_raw
            type: str
            size: 3
            #encoding: BCS-N-Pos-Int
            if: user_defined_image_data_length != 0
          - id: user_defined_image_data
            size: user_defined_image_data_length - 3
            if: user_defined_image_data_length != 0
          - id: image_extended_subheader_data_length_raw
            type: str
            size: 5
            #encoding: BCS-N-Pos-Int
          - id: image_extended_subheader_overflow_raw
            type: str
            size: 3
            #encoding: BCS-N-Pos-Int
            if: image_extended_subheader_data_length != 0
          - id: image_extended_subheader_data
            size: image_extended_subheader_data_length - 3
            if: image_extended_subheader_data_length != 0
        instances:
          number_of_significant_rows_in_image:
            value: number_of_significant_rows_in_image_raw.to_i
          number_of_significant_columns_in_image:
            value: number_of_significant_columns_in_image_raw.to_i
          actual_bits_per_pixel_per_band:
            value: actual_bits_per_pixel_per_band_raw.to_i
          number_of_image_comments:
            value: number_of_image_comments_raw.to_i
          number_of_bands:
            value: number_of_bands_raw.to_i
          number_of_multispectral_bands:
            value: number_of_multispectral_bands_raw.to_i
          number_of_blocks_per_row:
            value: number_of_blocks_per_row_raw.to_i
          number_of_blocks_per_column:
            value: number_of_blocks_per_column_raw.to_i
          number_of_pixels_per_block_horizontal:
            value: number_of_pixels_per_block_horizontal_raw.to_i
          number_of_pixels_per_block_vertical:
            value: number_of_pixels_per_block_vertical_raw.to_i
          number_of_bits_per_pixel_per_band:
            value: number_of_bits_per_pixel_per_band_raw.to_i
          image_display_level:
            value: image_display_level_raw.to_i
          attachment_level:
            value: attachment_level_raw.to_i
          user_defined_image_data_length:
            value: user_defined_image_data_length_raw.to_i
          user_defined_overflow:
            value: user_defined_overflow_raw.to_i
            if: user_defined_image_data_length == 0
          image_extended_subheader_data_length:
            value: image_extended_subheader_data_length_raw.to_i
          image_extended_subheader_overflow:
            value: image_extended_subheader_overflow_raw.to_i
            if: image_extended_subheader_data_length == 0
        types:
          band:
            seq:
              - id: representation
                type: u2
                enum: representations
              - id: subcategory
                type: str
                size: 6
                #encoding: BCS-A
              - id: image_filter_condition
                contents: [0x4E] #N
              - id: standard_image_filter_code
                contents: [0x20, 0x20, 0x20]
              - id: number_of_luts_raw
                type: str
                size: 1
                #encoding: BCS-N-Pos-Int
              - id: number_of_lut_entries_raw
                type: str
                size: 5
                #encoding: BCS-N-Pos-Int
                if: number_of_luts != 0
              - id: luts_in_each_band
                type: luts_in_band
                repeat: expr
                repeat-expr: number_of_luts
            instances:
              number_of_luts:
                value: number_of_luts_raw.to_i
              number_of_lut_entries:
                value: number_of_lut_entries_raw.to_i
            types:
              luts_in_band:
                seq:
                  - id: lut
                    type: u1
                    repeat: expr
                    repeat-expr: _parent.number_of_lut_entries
            enums:
              representations:
                0x2020: not_applicable
                0x4C55: lut #LU
                0x5220: red #R
                0x4720: green #G
                0x4220: blue #B
                0x4D20: monochrome #M
                0x5920: luminance #Y
                0x4362: chrominance_blue #Cb
                0x4372: chrominance_red #Cr
          image_location:
            seq:
              - id: row_raw
                type: str
                size: 5
                #encoding: BCS-N
              - id: column_raw
                type: str
                size: 5
                #encoding: BCS-N
            instances:
              row:
                value: row_raw.to_i
              column:
                value: column_raw.to_i
        enums:
          pixel_justifications:
            0x20: not_applicable
            0x46: left_justified #L
            0x52: right_justified #R
          image_coordinate_representations:
            0x20: not_applicable
            0x55: utm_mgrs #U
            0x47: geographic #G
            0x4E: utm_ups_northern_hemisphere #N
            0x53: utm_ups_southern_hemisphere #S
            0x44: decimal_degrees #D
          image_modes:
            0x42: band_interleaved_by_block #B
            0x50: band_interleaved_by_pixel #P
            0x52: band_interleaved_by_row #R
            0x53: band_sequential #S
      image_data_mask_table:
        seq:
          - id: blocked_image_data_offset
            type: u4
          - id: block_mask_record_length
            type: u2
          - id: pad_pixel_mask_record_length
            type: u2
          - id: pad_output_pixel_code_length
            type: u2
            doc: measured in number of bits
          #- id: pad_output_pixel_code
          #  size: ?
          #  if: pad_output_pixel_code_length != 0
          #TODO: CONTINUE HERE
    enums:
      image_compression_methods:
        0x2020: not_applicable
        0x4E43: uncompressed #NC
        0x4E4D: uncompressed_with_block_and_or_pad_pixel_mask #NM
        0x4331: bi_level #C1
        0x4333: jpeg #C2
        0x4334: vector_quantization #C4
        0x4335: lossless_jpeg #C5
        0x4336: reserved_correlated_multicomponent_compression_c #C6
        0x4337: reserved_sar_compression_c #C7
        0x4338: iso_iec_15444_1_2000_amd_1_amd_2_c #C8
        0x4931: down_sampled_jpeg #I1
        0x4D31: itu_t_t_4_amd_2 #M1
        0x4D33: mil_std_188_198a #M3
        0x4D34: mil_std_188_199 #M4
        0x4D35: nga_n0106_07 #M5
        0x4D36: reserved_correlated_multicomponent_compression_m #M6
        0x4D37: reserved_sar_compression_m #M7
        0x4D38: iso_iec_15444_1_2000_amd_1_amd_2_m #M8
  graphic_segment:
    seq:
      - id: header
        type: graphic_segment_header
      - id: data
        size: 0
    types:
      graphic_segment_header:
        seq:
          - id: nothing
            size: 1
  text_segment:
    seq:
      - id: header
        type: text_segment_header
      - id: data
        size: 0
    types:
      text_segment_header:
        seq:
          - id: nothing
            size: 1
  data_extension_segment:
    seq:
      - id: header
        type: data_extension_segment_header
      - id: data
        size: 0
    types:
      data_extension_segment_header:
        seq:
          - id: nothing
            size: 1
  reserved_extension_segment:
    seq:
      - id: header
        type: reserved_extension_segment_header
      - id: data
        size: 0
    types:
      reserved_extension_segment_header:
        seq:
          - id: nothing
            size: 1
  security_fields:
    seq:
      - id: security_classification
        type: u1
        enum: security_classification
      - id: security_classification_system
        type: u2
        enum: multilateral_entity_digraphs
      - id: codewords
        type: codeword_digraph_list
      - id: control_and_handling
        type: u2
        enum: security_control_marking_digraphs
      - id: releasing_instructions
        type: multilateral_entity_digraph_list
      - id: declassification_type
        type: u2
        enum: declassification_type
      - id: declassification_date
        type: date
      - id: declassification_exemption
        type: u4
        enum: declassification_exemption
      - id: downgrade_classification
        type: u1
        enum: downgrade_security_classification
      - id: downgrade_date
        type: date
      - id: classification_text
        type: str
        size: 43
        #encoding: ECS-A
      - id: classification_authority_type
        type: u1
        enum: classification_authority_type
      - id: classification_authority
        type: str
        size: 40
        #encoding: ECS-A
      - id: classification_reason
        type: u1
        enum: classification_reason
      - id: source_date
        type: date
      - id: control_number
        type: str
        size: 15
        #encoding: ECS-A
    types:
      codeword_digraph_list:
        seq:
          - id: codeword_1
            type: u2
            enum: security_control_marking_digraphs
          - id: spacer_1
            contents: [0x20]
          - id: codeword_2
            type: u2
            enum: security_control_marking_digraphs
          - id: spacer_2
            contents: [0x20]
          - id: codeword_3
            type: u2
            enum: security_control_marking_digraphs
          - id: spacer_3
            contents: [0x20]
          - id: codeword_4
            type: u2
            enum: security_control_marking_digraphs
      multilateral_entity_digraph_list:
        seq:
          - id: multilateral_entity_1
            type: u2
            enum: multilateral_entity_digraphs
          - id: spacer_1
            contents: [0x20]
          - id: multilateral_entity_2
            type: u2
            enum: multilateral_entity_digraphs
          - id: spacer_2
            contents: [0x20]
          - id: multilateral_entity_3
            type: u2
            enum: multilateral_entity_digraphs
          - id: spacer_3
            contents: [0x20]
          - id: multilateral_entity_4
            type: u2
            enum: multilateral_entity_digraphs
          - id: spacer_4
            contents: [0x20]
          - id: multilateral_entity_5
            type: u2
            enum: multilateral_entity_digraphs
          - id: spacer_5
            contents: [0x20]
          - id: multilateral_entity_6
            type: u2
            enum: multilateral_entity_digraphs
          - id: spacer_6
            contents: [0x20]
          - id: multilateral_entity_7
            type: u2
            enum: multilateral_entity_digraphs
    enums:
      security_classification:
        0x54: top_secret #T
        0x53: secret #S
        0x43: confidential #C
        0x52: restricted #R
        0x55: unclassified #U
      downgrade_security_classification:
        0x20: not_applicable
        0x53: secret #S
        0x43: confidential #C
        0x52: restricted #R
      security_control_marking_digraphs:
        0x2020: not_used
        0x4154: atomal #AT
        0x434E: cnwdi #CN
        0x5058: copyright #PX
        0x4353: cosmic #CS
        0x4352: crypto #CR
        0x5458: efto #TX
        0x5246: formrest_data #RF
        0x464F: fouo #FO
        0x4753: general_service #GS
        0x4C55: lim_off_use #LU
        0x4453: limdis #DS
        0x4E53: nato #NS
        0x4E43: no_contract #NC
        0x4E54: noncompartment #NT
        0x4F52: orcon #OR
        0x494E: personal_data #IN
        0x5049: propin #PI
        0x5244: restricted_data #RD
        0x5341: sao #SA
        0x534C: sao_1 #SL
        0x4841: sao_2 #HA
        0x4842: sao_3 #HB
        0x534B: sao_si_2 #SK
        0x4843: sao_si_3 #HC
        0x4844: sao_si_4 #HD
        0x5348: siop #SH
        0x5345: siop_esi #SE
        0x5343: special_control #SC
        0x5349: special_intel #SI
        0x554F: us_only #UO
        0x574E: warning_notice #WN
        0x5749: wnintel #WI
      declassification_type:
        0x2020: not_applicable
        0x4444: declassify_on_specific_date #DD
        0x4445: declassify_upon_occurence_of_event #DE
        0x4744: downgrade_to_specified_level_on_specific_date #GD
        0x4745: downgrade_to_specified_level_upon_occurence_of_event #GE
        0x4F20: oadr #O
        0x5820: exempt_from_automatic_declassification #X
      declassification_exemption:
        0x20202020: not_applicable
        0x58312020: x1 #X1
        0x58322020: x2 #X2
        0x58332020: x3 #X3
        0x58342020: x4 #X4
        0x58352020: x5 #X5
        0x58362020: x6 #X6
        0x58372020: x7 #X7
        0x58382020: x8 #X8
        0x58323531: x251 #X251
        0x58323532: x252 #X252
        0x58323533: x253 #X253
        0x58323534: x254 #X254
        0x58323535: x255 #X255
        0x58323536: x256 #X256
        0x58323537: x257 #X257
        0x58323538: x258 #X258
        0x58323539: x259 #X259
      classification_authority_type:
        0x20: not_applicable
        0x4F: original_classification_authority #O
        0x44: derivative_from_single_source #D
        0x4D: derivative_from_multiple_sources #M
      classification_reason:
        0x20: not_applicable
        0x41: a #A
        0x42: b #B
        0x43: c #C
        0x44: d #D
        0x45: e #E
        0x46: f #F
        0x47: g #G
  date:
    seq:
      - id: century_raw
        type: str
        size: 2
        #encoding: BCS-N-Int
      - id: year_raw
        type: str
        size: 2
        #encoding: BCS-N-Int
      - id: month_raw
        type: str
        size: 2
        #encoding: BCS-N-Int
      - id: day_raw
        type: str
        size: 2
    instances:
      century:
        value: century_raw.to_i
      year:
        value: year_raw.to_i
      month:
        value: month_raw.to_i
      day:
        value: day_raw.to_i
  date_and_time:
    seq:
      - id: century_raw
        type: str
        size: 2
        #encoding: BCS-N-Int
      - id: year_raw
        type: str
        size: 2
        #encoding: BCS-N-Int
      - id: month_raw
        type: str
        size: 2
        #encoding: BCS-N-Int
      - id: day_raw
        type: str
        size: 2
        #encoding: BCS-N-Int
      - id: hour_raw
        type: str
        size: 2
        #encoding: BCS-N-Int
      - id: minute_raw
        type: str
        size: 2
        #encoding: BCS-N-Int
      - id: second_raw
        type: str
        size: 2
        #encoding: BCS-N-Int
    instances:
      century:
        value: century_raw.to_i
      year:
        value: year_raw.to_i
      month:
        value: month_raw.to_i
      day:
        value: day_raw.to_i
      hour:
        value: hour_raw.to_i
      minute:
        value: minute_raw.to_i
      second:
        value: second_raw.to_i
  rgb_color:
    seq:
      - id: red
        type: u1
      - id: green
        type: u1
      - id: blue
        type: u1
  target_identifier:
    seq:
      - id: basic_encyclopedia_identifier
        type: str
        size: 10
        #encoding: BCS-A
      - id: facility_o_suffix
        type: str
        size: 5
        #encoding: BCS-A
      - id: country_code
        type: u2
        enum: multilateral_entity_digraphs
enums:
  multilateral_entity_digraphs:
    0x2020: not_used
    0x5553: united_states #US
    #full list in FIPS PUB 10-4: http://geonames.nga.mil/gns/html/PDFDocs/GEOPOLITICAL_CODES.pdf
