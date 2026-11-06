# frozen_string_literal: true

require "thor"

class Mappings < Mapviz::CommandOpts
  desc "graph", "Render and open flowchart of all mappings"
  shared_options(:exclude_omitted, :exclude_unmapped)
  def graph
    check_for_mmdcli

    mappings = Mapviz::Mappings.new.filter(
      omitted: options[:exclude_omitted],
      unmapped: options[:exclude_unmapped]
    )
    path = create("mappings", mappings)
    `open #{path}`
    exit(0)
  end

  desc "graphs", "Render and save flowcharts of all individual to/from mappings"
  shared_options(:exclude_omitted, :exclude_unmapped)
  def graphs
    check_for_mmdcli

    all_mappings = Mapviz::Mappings.new

    Mapviz.orig_sources.each do |field|
      mappings = all_mappings.for_source(
        source: field,
        exclude_omitted: options[:exclude_omitted],
        exclude_unmapped: options[:exclude_unmapped]
      )

      create("from_#{filesafe(field)}", mappings)
    end

    Mapviz.targets.each do |field|
      mappings = all_mappings.for_target(
        target: field,
        exclude_omitted: options[:exclude_omitted],
        exclude_unmapped: options[:exclude_unmapped]
      )

      name = target_for_file(mappings)
      create("to_#{filesafe(name)}", mappings)
    end
    exit(0)
  end

  desc "from", "Render flowchart of mappings from a single source field"
  method_option :sourcefield,
    required: true,
    aliases: "-s",
    type: :string,
    desc: "The source field to output mappings for"
  shared_options(:exclude_omitted, :exclude_unmapped)
  def from
    check_for_mmdcli

    mappings = Mapviz::Mappings.new.for_source(
      source: options[:sourcefield],
      exclude_omitted: options[:exclude_omitted],
      exclude_unmapped: options[:exclude_unmapped]
    )

    path = create(options[:sourcefield], mappings)
    `open #{path}`
    exit(0)
  end

  desc "to", "Render flowchart of mappings to target field"
  method_option :targetfield,
    required: true,
    aliases: "-t",
    type: :string,
    desc: "Target fields for which to output mappings"
  def to
    check_for_mmdcli

    mappings = Mapviz::Mappings.new
      .for_target(target: options[:targetfield])

    name = target_for_file(mappings)
    path = create("to_#{filesafe(name)}", mappings)
    `open #{path}`
    exit(0)
  end

  no_commands do
    def check_for_mmdcli
      return if mermaid_cli_installed?

      puts "mmd-cli (Mermaid CLI) command not installed or not found on "\
        "path. See README for installation instructions if you wish to use "\
        "this command."
      exit(1)
    end

    def mermaid_cli_installed?
      result = `which mmd-cli`
      true unless result.empty?
    end

    def dir
      dir = Kiba::Extend::ProjectConfig.graph_dir
      unless dir
        puts "TIP: Add `Kiba::Extend::ProjectConfig.config.graph_dir = "\
          "\"path_to_directory_for_your_project\" to your project config, "\
          "so your graphs can be saved with your other project files."
      end

      dir
    end

    def target_for_file(mappings)
      final = mappings.find { |m| Mapviz::Logic.is_final_target.call(m) }
      Mapviz::Labels.final_target_node.call(final)
        .sub("\n", "_")
    end

    def filesafe(str) = str.tr(" ", "_").gsub(/\W/, "")

    def create(name, mappings)
      path = File.join(Mapviz::Path.mermaid_dir, "#{name}.mmd")
      Mapviz::MermaidWriter.new(mappings: mappings, path: path).call

      pdf_path = File.join(Mapviz::Path.pdf_dir, "#{name}.pdf")
      configpath = Mapviz::Path.mermaid_render_config_file

      if configpath
        `mmd-cli -i #{path} -o #{pdf_path} -f -c #{configpath}`
      else
        `mmd-cli -i #{path} -o #{pdf_path} -f`
      end

      pdf_path
    end
  end
end
