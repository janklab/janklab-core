package net.janklab.colstyledtable;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import static java.util.Objects.requireNonNull;

/**
 * A controller that adjusts the size of fonts in a set of related components. This is
 * useful for implementing user-visible "Increase Font Size"/"Decrease Font Size" controls.
 * The font sizes it can adjust to are snapped to an explicit list of particular font
 * sizes.
 *
 * It assumes that all of its controlled components have the same font size, and that they
 * should be linked so they always have the same font size.
 */
public class FontSizeAdjuster {

    public static List<Float> DEFAULT_SIZES = Arrays.asList(6f, 7f, 8f, 9f, 10f, 11f, 12f,
            13f, 14f, 18f, 20f, 24f, 30f, 36f, 48f, 60f);

    private List<JComponent> components;
    private float[] referenceSizes;

    private Action increaseSizeAction = new IncreaseSizeAction();
    private Action decreaseSizeAction = new DecreaseSizeAction();

    public FontSizeAdjuster(Collection<JComponent> components) {
        this(DEFAULT_SIZES, components);
    }

    public FontSizeAdjuster(float[] referenceSizes, Collection<JComponent> components) {
        this.components = new ArrayList<>(components);
        requireSorted(referenceSizes);
        if (referenceSizes.length < 1) {
            throw new IllegalArgumentException("referenceSizes must be at least 1 element long");
        }
        this.referenceSizes = Arrays.copyOf(referenceSizes, referenceSizes.length);
    }

    public FontSizeAdjuster(List<Float> referenceSizes, Collection<JComponent> components) {
        this(floatListToArray(referenceSizes), components);
    }

    private static void requireSorted(float[] x) {
        if (x.length < 2) {
            return;
        }
        for (int i = 1; i < x.length; i++) {
            if (x[i] <= x[i-1]) {
                throw new IllegalArgumentException(String.format("Input must be sorted, but x[%d] (%f) is not > x[%d] (%f)",
                        i, x[i], i-1, x[i-1]));
            }
        }
    }

    public void addComponent(JComponent component) {
        components.add(requireNonNull(component));
    }

    public void removeComponent(JComponent component) {
        components.remove(requireNonNull(component));
    }

    private float getCurrentSize() {
        if (components.isEmpty()) {
            return 0;
        }
        return components.get(0).getFont().getSize2D();
    }

    public void installKeystrokeHandlerOnAllComponents() {
        for (JComponent component : components) {
            InputMap inputMap = component.getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);
            String increaseFontSizeKey = "increaseFontSize";
            String decreaseFontSizeKey = "decreaseFontSize";
            inputMap.put(KeyStroke.getKeyStroke("ctrl EQUALS"), increaseFontSizeKey);
            inputMap.put(KeyStroke.getKeyStroke("ctrl MINUS"), decreaseFontSizeKey);
            inputMap.put(KeyStroke.getKeyStroke("meta EQUALS"), increaseFontSizeKey);
            inputMap.put(KeyStroke.getKeyStroke("meta MINUS"), decreaseFontSizeKey);
            component.getActionMap().put(increaseFontSizeKey, increaseSizeAction);
            component.getActionMap().put(decreaseFontSizeKey, decreaseSizeAction);
        }
    }

    /**
     * Returns the current size as an index
     * @return index, between 0 and referenceSizes.length - 1
     */
    private int currentSizeIndex() {
        float size = getCurrentSize();
        int i;
        for (i = 0; i < referenceSizes.length; i++) {
            if (size <= referenceSizes[i]) {
                break;
            }
        }
        // Snap to max size
        if (i == referenceSizes.length) {
            i = referenceSizes.length - 1;
        }
        return i;
    }

    public void increaseSize() {
        int i = currentSizeIndex();
        applyNewSize((i < referenceSizes.length - 1) ? referenceSizes[i+1]
                : referenceSizes[referenceSizes.length-1]);
    }

    public void decreaseSize() {
        int i = currentSizeIndex();
        applyNewSize((i > 0) ? referenceSizes[i - 1]
                : referenceSizes[0]);
    }

    private void applyNewSize(float newSize) {
        for (JComponent component : components) {
            component.setFont(component.getFont().deriveFont(newSize));
        }
    }

    private static float[] floatListToArray(List<Float> floats) {
        float[] out = new float[floats.size()];
        for (int i = 0; i < floats.size(); i++) {
            out[i] = floats.get(i);
        }
        return out;
    }

    private class IncreaseSizeAction extends AbstractAction {

        @Override
        public void actionPerformed(ActionEvent e) {
            increaseSize();
        }
    }

    private class DecreaseSizeAction extends AbstractAction {

        @Override
        public void actionPerformed(ActionEvent e) {
            decreaseSize();
        }
    }

}
