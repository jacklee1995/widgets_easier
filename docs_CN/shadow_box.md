

### 2. 阴影盒子

#### 2.1 阴影盒子介绍

受启发于 **[Element-Plus](https://element-plus.org/)** 在 **Widgets Easier** 组件库中，提供了特定阴影效果。这些阴影效果能够以组件的方式为其它的组件添加相对应的阴影效果。

于 **[Element-Plus](https://element-plus.org/)** 类似， 在 **Widgets Easier** 库中，典型的阴影效果被封装为以下四个组件：**BasicShadow**、**LightShadow**、**LighterShadow**、**DarkShadow**，每个组件都使用 **DecoratedBox** 来实现特定的阴影效果。

![example_kAfLS9VvwG](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics//example_kAfLS9VvwG.png)



#### 2.2 BasicShadow

`BasicShadow` 是一个提供基本阴影效果的组件。它使用 `DecoratedBox` 来实现阴影，适用于需要轻微突出显示的元素。这种阴影效果不太强烈，但足以给元素添加一些深度和立体感。

```dart
BasicShadow(
  child: Container(
    height: 100,
    width: 100,
    color: Colors.white,
    child: const Center(
      child: Text('BasicShadow'),
    ),
  ),
)
```

#### 2.3 LightShadow

`LightShadow` 提供的是比 `BasicShadow` 更轻的阴影效果。它同样使用 `DecoratedBox`，阴影更加细微，适合不需要太多突出但又想有细微区分的界面元素。

```dart
LightShadow(
  child: Container(
    height: 100,
    width: 100,
    color: Colors.white,
    child: const Center(
      child: Text('LightShadow'),
    ),
  ),
)
```

#### 2.4 LighterShadow

`LighterShadow` 是四种阴影中最轻的一种。它几乎不可见，只在必要时提供最轻微的阴影效果，适用于极为细腻的用户界面设计，其中每一个细节都需要精心处理。

```dart
LighterShadow(
  child: Container(
    height: 100,
    width: 100,
    color: Colors.white,
    child: const Center(
      child: Text('LighterShadow'),
    ),
  ),
)
```

#### 2.5 DarkShadow

`DarkShadow` 提供的是最强烈的阴影效果，使用 `DecoratedBox` 实现。这种阴影适用于需要明显区分的元素，可以显著提升元素的视觉层次感和吸引用户的注意力。

```dart
DarkShadow(
  child: Container(
    height: 100,
    width: 100,
    color: Colors.white,
    child: const Center(
      child: Text('DarkShadow'),
    ),
  ),
)
```



