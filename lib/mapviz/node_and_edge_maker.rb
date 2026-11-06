# frozen_string_literal: true

module Mapviz
  # Generates Nodes and Edges from a Mapping
  class NodeAndEdgeMaker
    # @param mapping [Mapviz::Mapping]
    def initialize(mapping)
      @mapping = mapping
    end

    # @return [Array<Mapviz::Node>]
    def nodes = [source, constraint, detail, target].compact

    # @return [Array<Mapviz::Edge>]
    def edges = derive_edges(nodes).flatten

    private

    attr_reader :mapping

    def source
      field = Mapviz::Values.source.call(mapping)
      return if field.blank?

      Mapviz::Node.new(id: source_id, label: field, type: source_type)
    end

    def constraint
      return unless constrained?

      val = Mapviz::Values.constraint.call(mapping)
      Mapviz::Node.new(id: constraint_id, label: val, type: :constraint)
    end

    def detail
      return unless detailed?

      val = Mapviz::Values.detail.call(mapping)
      Mapviz::Node.new(id: detail_id, label: val, type: :detail)
    end

    def target
      if target_type == :omitted
        return Mapviz::Node.new(
          id: "omitted",
          label: Mapviz::Labels.omitted_node.call(mapping),
          type: target_type
        )
      end

      if target_type == :unmapped
        return Mapviz::Node.new(
          id: "unmapped",
          label: Mapviz::Labels.unmapped_node.call(mapping),
          type: target_type
        )
      end

      Mapviz::Node.new(id: target_id, label: target_label, type: target_type)
    end

    def derive_edges(arr)
      result = []
      until arr.length == 1
        src = arr.shift
        result << Mapviz::Edge.new(source: src, target: arr.first)
      end

      result
    end

    def constrained? = !Mapviz::Values.constraint.call(mapping).blank?

    def detailed? = !Mapviz::Values.detail.call(mapping).blank?

    def source_type = if Mapviz::Logic.is_orig.call(mapping)
                        :orig
                      elsif Mapviz::Logic.is_intermediate_source.call(mapping)
                        :intermediate
                      else
                        :unknown
                      end

    def target_type = if Mapviz::Logic.is_omitted.call(mapping)
                        :omitted
                      elsif Mapviz::Logic.is_unmapped.call(mapping)
                        :unmapped
                      elsif Mapviz::Logic.is_intermediate_target.call(mapping)
                        :intermediate
                      elsif Mapviz::Logic.is_final_target.call(mapping) &&
                          Mapviz::Logic.is_loaded.call(mapping)
                        :final_loaded
                      elsif Mapviz::Logic.is_final_target.call(mapping)
                        :final
                      else
                        :unknown
                      end

    def id(str) = str.downcase
      .gsub(/\W/, "_")
      .sub(/_$/, "")

    def source_id = id(Mapviz::Values.source.call(mapping))

    def constraint_id = [source_id,
      id(Mapviz::Values.constraint.call(mapping))].join("_").gsub(/__+/, "_")

    def detail_id = [target_id,
      id(Mapviz::Values.detail.call(mapping))].join("_").gsub(/__+/, "_")

    def target_id
      val = if final?
        Mapviz::Values.target_id.call(mapping)
      else
        Mapviz::Values.target_field_machine.call(mapping)
      end
      id(val)
    end

    def target_label = if final?
                         Mapviz::Labels.final_target_node.call(mapping)
                       else
                         Mapviz::Labels.intermediate_target_node.call(mapping)
                       end

    def final? = target_type.to_s.start_with?("final")
  end
end

__END__

source orig
source int
constraint
target int
target final

source states: mapped, omitted, unmapped

target states: loaded, not loaded
detail is in target label
