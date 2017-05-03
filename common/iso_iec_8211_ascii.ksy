meta:
  id: iso_iec_8211_ascii
  file-extension: iso_iec_8211_ascii
  encoding: ASCII
seq:
  - id: data_descriptive_record
    type: data_descriptive_record
types:
  data_descriptive_record:
    seq:
      - id: leader
        type: data_descriptive_record_leader
        size: 24
      - id: directory
        type: data_descriptive_record_directory
        size: leader.dda_base - 25
      - id: terminator
        contents: [0x1E]
    types:
      data_descriptive_record_leader:
        seq:
          - id: record_length_raw
            type: str
            size: 5
          - id: interchange_level_raw
            type: str
            size: 1
          - id: leader_id_raw
            type: str
            size: 1
          - id: extension_flag_raw
            type: str
            size: 1
          - id: reserved_raw
            type: str
            size: 1
          - id: application_flag_raw
            type: str
            size: 1
          - id: field_control_length_raw
            type: str
            size: 2
          - id: dda_base_raw
            type: str
            size: 5
          - id: extended_raw
            type: str
            size: 3
          - id: length_size_raw
            type: str
            size: 1
          - id: position_size_raw
            type: str
            size: 1
          - id: reserved_2_raw
            type: str
            size: 1
          - id: tag_size_raw
            type: str
            size: 1
        instances:
          record_length:
            value: record_length_raw.to_i
          interchange_level:
            value: interchange_level_raw.to_i
          leader_id:
            value: leader_id_raw.to_i
          extension_flag:
            value: extension_flag_raw.to_i
          application_flag:
            value: application_flag_raw.to_i
          field_control_length:
            value: field_control_length_raw.to_i
          dda_base:
            value: dda_base_raw.to_i
          extended:
            value: extended_raw.to_i
          length_size:
            value: length_size_raw.to_i
          position_size:
            value: position_size_raw.to_i
          tag_size:
            value: tag_size_raw.to_i
      data_descriptive_record_directory:
        seq:
          - id: entries
            type: data_descriptive_record_directory_entry
            repeat: eos
        types:
          data_descriptive_record_directory_entry:
            seq:
              - id: tag
                type: str
                size: _parent._parent.leader.tag_size
              - id: length_raw
                type: str
                size: _parent._parent.leader.length_size
              - id: position_raw
                type: str
                size: _parent._parent.leader.position_size
            instances:
              length:
                value: length_raw.to_i
              position:
                value: position_raw.to_i
              data_descriptive_area_entry:
                pos: 0
                type: data_descriptive_area_entry
                size: length
            types:
              data_descriptive_area_entry:
                seq:
                  - id: controls
                    size: 9