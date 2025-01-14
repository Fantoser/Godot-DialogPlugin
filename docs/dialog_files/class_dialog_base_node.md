# DialogBaseNode
#### **Inherits:** [CanvasItem][canvas_item_class]

[canvas_item_class]:https://docs.godotengine.org/en/stable/classes/class_canvasitem.html

Base class of any `Dialog` node.

## Description
`Dialog` nodes inheriths this class. This class works as a "Dialog Manager".

## Properties
Type|Name
---|---
String|[timeline_name](#-string-timeline_name)
NodePath|[DialogNode_path](#-nodepath-dialognode_path)
NodePath|[PortraitsNode_path](#-nodepath-portraitsnode_path)
DialogTimelineResource|[timeline](#-dialogtimelineresource-timeline)
float|[text_speed](#-float-text_speed)
bool|[event_finished](#-bool-event_finished)
String|[next_input](#-string-next_input)
DialogDialogueNode|[DialogNode](#-dialogdialoguenode-dialognode)
DialogPortraitManager|[PortraitManager](#-dialogportraitmanager-portraitmanager)

## Methods
Type|Name
---|---
void|[start_timeline](#-void-start_timeline--) ( )
DialogTimelineResource|[load_timeline](#-dialogtimelineresource-load_timeline--) ( )

## Signals
## Enumerations
## Constants
- DialogUtil
## Property Descriptions
### ◽ String timeline_name
### ◽ DialogTimelineResource timeline
### ◽ NodePath DialogNode_path
### ◽ NodePath PortraitsNode_path
### ◽ float text_speed
### ◽ bool event_finished
### ◽ String next_input
### ◽ DialogDialogueNode DialogNode
### ◽ DialogPortraitManager PortraitManager
## Method Descriptions
### ◽ void **start_timeline** ( )
### ◽ DialogTimelineResource **load_timeline** ( )